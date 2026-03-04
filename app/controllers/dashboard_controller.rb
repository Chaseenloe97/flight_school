class DashboardController < ApplicationController
  before_action :require_login

  def show
    @flight_schools = current_user.flight_schools.includes(aircrafts: :downtime_events)
    all_aircraft = @flight_schools.flat_map(&:aircrafts)
    @total_aircraft = all_aircraft.size
    @aircraft_down = all_aircraft.count(&:currently_down?)
    @aircraft_available = @total_aircraft - @aircraft_down

    # Activity feed: recent downtime events and maintenance logs across all schools
    aircraft_ids = all_aircraft.map(&:id)
    @recent_downtime_events = DowntimeEvent.where(aircraft_id: aircraft_ids)
                                           .includes(:aircraft)
                                           .order(created_at: :desc)
                                           .limit(10)
    @recent_maintenance_logs = MaintenanceLog.where(aircraft_id: aircraft_ids)
                                             .includes(:aircraft)
                                             .order(created_at: :desc)
                                             .limit(10)

    # Fleet stats
    @upcoming_returns = DowntimeEvent.where(aircraft_id: aircraft_ids)
                                     .where("started_at <= ? AND ended_at > ?", Time.current, Time.current)
                                     .includes(:aircraft)
                                     .order(:ended_at)

    all_events = DowntimeEvent.where(aircraft_id: aircraft_ids)
    @total_downtime_events = all_events.count
    @reason_counts = all_events.group(:reason_type).count.sort_by { |_, v| -v }

    # Total downtime hours (completed events only)
    completed_events = all_events.where.not(ended_at: nil).where("ended_at <= ?", Time.current)
    @total_downtime_hours = completed_events.sum do |event|
      ((event.ended_at - event.started_at) / 1.hour).round(1)
    end
  end
end
