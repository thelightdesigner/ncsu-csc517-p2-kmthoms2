class Event < ApplicationRecord
  has_many :volunteer_assignments, dependent: :destroy
  has_many :volunteers, through: :volunteer_assignments

  enum :status, { open: 0, full: 1, completed: 2, cancelled: 3 }, default: :open

  validates :title, :description, :location, :event_date, :start_time, :end_time, :required_volunteer_count, presence: true
  validates :required_volunteer_count, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than_or_equal_to: 2_147_483_647
  }
  validate :start_time_before_end_time

  after_save :refresh_capacity_status!, if: :saved_change_to_required_volunteer_count?

  def assigned_volunteer_count
    current_assigned_volunteer_count
  end

  def pending_assignments_count
    volunteer_assignments.pending.count
  end

  def slots_available?
    assigned_volunteer_count < required_volunteer_count
  end

  def open_for_signup?
    open? && slots_available?
  end

  def duration_hours
    return 0 if start_time.blank? || end_time.blank?

    ((end_time - start_time) / 1.hour).to_f
  end

  def refresh_capacity_status!
    return if completed? || cancelled?

    target_status = slots_available? ? :open : :full
    update_column(:status, Event.statuses[target_status]) if status != target_status.to_s
  end

  def sync_assignment_totals!
    count = volunteer_assignments.assigned_for_capacity.count
    update_column(:current_assigned_volunteer_count, count) if current_assigned_volunteer_count != count
    refresh_capacity_status!
  end

  private

  def start_time_before_end_time
    return if start_time.blank? || end_time.blank?
    return if start_time < end_time

    errors.add(:start_time, "must be before end time")
  end
end
