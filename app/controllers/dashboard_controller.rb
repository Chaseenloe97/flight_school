class DashboardController < ApplicationController
  before_action :require_login

  def show
    @flight_schools = current_user.flight_schools.includes(aircrafts: :downtime_events)
    @total_aircraft = @flight_schools.sum { |fs| fs.aircrafts.size }
    @aircraft_down = @flight_schools.flat_map(&:aircrafts).count(&:currently_down?)
    @aircraft_available = @total_aircraft - @aircraft_down
  end
end
