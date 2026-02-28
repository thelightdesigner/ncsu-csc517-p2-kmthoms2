class VolunteerAssignment < ApplicationRecord
  belongs_to :volunteer
  belongs_to :event

  enum :status, { pending: 0, approved: 1, withdrawn: 2, removed: 3, completed: 4 }, default: :pending
  scope :assigned_for_capacity, -> { where(status: [ statuses[:approved], statuses[:completed] ]) }

  validates :volunteer_id, uniqueness: { scope: :event_id }
  validates :status, presence: true
  validates :hours_worked, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validate :hours_within_event_duration
  validate :hours_only_for_participated_event
  validate :completed_requires_completed_event
  validate :cannot_exceed_event_capacity, if: :counts_toward_capacity?

  after_commit :sync_related_event, on: %i[create update destroy]

  private

  def sync_related_event
    related_event = Event.find_by(id: event_id)
    related_event&.sync_assignment_totals!
  end

  def hours_within_event_duration
    return if hours_worked.blank? || event.blank?
    return if hours_worked <= event.duration_hours

    errors.add(:hours_worked, "cannot exceed event duration")
  end

  def hours_only_for_participated_event
    return if hours_worked.blank?
    return if approved? || completed?

    errors.add(:hours_worked, "can only be logged for approved volunteers")
  end

  def completed_requires_completed_event
    return unless status == "completed"
    return if event&.completed?

    errors.add(:status, "can only be marked completed when the event is completed")
  end

  def counts_toward_capacity?
    approved? || completed?
  end

  def cannot_exceed_event_capacity
    return if event.blank?

    assigned_count_without_self = event.volunteer_assignments.assigned_for_capacity.where.not(id: id).count
    return if assigned_count_without_self < event.required_volunteer_count

    errors.add(:base, "Event has no available volunteer slots")
  end
end
