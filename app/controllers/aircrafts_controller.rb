class AircraftsController < ApplicationController
  before_action :require_login
  before_action :set_flight_school
  before_action :set_aircraft, only: %i[show edit update destroy]

  def show
    @downtime_events = @aircraft.downtime_events.order(started_at: :desc)
    @maintenance_logs = @aircraft.maintenance_logs.order(logged_at: :desc)
    @active_downtime = @aircraft.active_downtime_event
  end

  def new
    @aircraft = @flight_school.aircrafts.build
  end

  def create
    @aircraft = @flight_school.aircrafts.build(aircraft_params)
    if @aircraft.save
      redirect_to flight_school_aircraft_path(@flight_school, @aircraft), notice: "Aircraft added to fleet."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @aircraft.update(aircraft_params)
      redirect_to flight_school_aircraft_path(@flight_school, @aircraft), notice: "Aircraft updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @aircraft.destroy
    redirect_to flight_school_path(@flight_school), notice: "Aircraft removed from fleet."
  end

  private

  def set_flight_school
    @flight_school = current_user.flight_schools.find(params[:flight_school_id])
  end

  def set_aircraft
    @aircraft = @flight_school.aircrafts.find(params[:id])
  end

  def aircraft_params
    params.require(:aircraft).permit(:tail_number, :model, :notes)
  end
end
