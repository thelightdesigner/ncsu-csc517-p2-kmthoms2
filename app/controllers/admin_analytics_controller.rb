class AdminAnalyticsController < ApplicationController
  before_action :require_admin

  def index
    @filters = analytics_filters
    @events = Event.order(:event_date, :start_time)
    @volunteers = Volunteer.order(:full_name)

    assignments = filtered_completed_assignments
    @volunteer_activity_summary = build_volunteer_activity_summary(assignments)
    @event_participation_summary = build_event_participation_summary(assignments)
    @top_volunteers = build_top_volunteers(@volunteer_activity_summary)
    @low_participation_volunteers = build_low_participation(assignments)
  end

  private

  def filtered_completed_assignments
    assignments = VolunteerAssignment.completed
                                    .joins(:event)
                                    .where(events: { status: Event.statuses[:completed] })

    if @filters[:date_from].present?
      assignments = assignments.where("events.event_date >= ?", @filters[:date_from])
    end

    if @filters[:date_to].present?
      assignments = assignments.where("events.event_date <= ?", @filters[:date_to])
    end

    if @filters[:event_id].present?
      assignments = assignments.where(event_id: @filters[:event_id])
    end

    if @filters[:volunteer_id].present?
      assignments = assignments.where(volunteer_id: @filters[:volunteer_id])
    end

    assignments
  end

  def build_volunteer_activity_summary(assignments)
    rows = assignments.joins(:volunteer)
                      .group("volunteers.id", "volunteers.full_name")
                      .order("volunteers.full_name")
                      .pluck(
                        "volunteers.id",
                        "volunteers.full_name",
                        "COUNT(DISTINCT volunteer_assignments.event_id)",
                        "COALESCE(SUM(volunteer_assignments.hours_worked), 0)"
                      )

    rows.map do |volunteer_id, volunteer_name, events_participated, total_hours|
      events_count = events_participated.to_i
      hours = total_hours.to_f

      {
        volunteer_id: volunteer_id,
        volunteer_name: volunteer_name,
        events_participated: events_count,
        total_hours: hours,
        average_hours_per_event: events_count.positive? ? hours / events_count : 0.0
      }
    end
  end

  def build_event_participation_summary(assignments)
    rows = assignments.joins(:event)
                      .group("events.id", "events.title")
                      .order("events.title")
                      .pluck(
                        "events.id",
                        "events.title",
                        "COUNT(DISTINCT volunteer_assignments.volunteer_id)",
                        "COALESCE(SUM(volunteer_assignments.hours_worked), 0)"
                      )

    rows.map do |event_id, event_title, volunteer_count, total_hours|
      volunteers_count = volunteer_count.to_i
      hours = total_hours.to_f

      {
        event_id: event_id,
        event_title: event_title,
        volunteer_count: volunteers_count,
        total_hours: hours,
        average_hours_per_volunteer: volunteers_count.positive? ? hours / volunteers_count : 0.0
      }
    end
  end

  def build_top_volunteers(summary_rows)
    ranked = if @filters[:top_metric] == "events"
      summary_rows.sort_by { |row| [-row[:events_participated], -row[:total_hours], row[:volunteer_name]] }
    else
      summary_rows.sort_by { |row| [-row[:total_hours], -row[:events_participated], row[:volunteer_name]] }
    end

    ranked.first(@filters[:top_n])
  end

  def build_low_participation(assignments)
    volunteer_scope = Volunteer.order(:full_name)
    volunteer_scope = volunteer_scope.where(id: @filters[:volunteer_id]) if @filters[:volunteer_id].present?

    participating_ids = assignments.distinct.pluck(:volunteer_id)
    volunteer_scope.where.not(id: participating_ids)
  end

  def analytics_filters
    date_from = safe_date(params[:date_from])
    date_to = safe_date(params[:date_to])
    top_n = params[:top_n].to_i

    {
      date_from: date_from,
      date_to: date_to,
      event_id: params[:event_id].presence,
      volunteer_id: params[:volunteer_id].presence,
      top_metric: %w[hours events].include?(params[:top_metric]) ? params[:top_metric] : "hours",
      top_n: top_n.between?(1, 100) ? top_n : 5
    }
  end

  def safe_date(value)
    return nil if value.blank?

    Date.parse(value.to_s)
  rescue ArgumentError
    nil
  end
end
