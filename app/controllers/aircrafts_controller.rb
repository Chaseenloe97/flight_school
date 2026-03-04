class AircraftsController < ApplicationController
  before_action :require_login
  before_action :set_flight_school
  before_action :set_aircraft, only: %i[show edit update destroy mark_down mark_available]

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

  def mark_down
    event = @aircraft.downtime_events.build(
      started_at: Time.current,
      ended_at: params[:ended_at].present? ? params[:ended_at] : nil,
      reason_type: params[:reason_type] || "breakdown",
      description: params[:description],
      created_by: current_user
    )
    if event.save
      redirect_to flight_school_path(@flight_school), notice: "#{@aircraft.tail_number} marked as down."
    else
      redirect_to flight_school_path(@flight_school), alert: "Could not mark aircraft down: #{event.errors.full_messages.join(', ')}"
    end
  end

  def mark_available
    active_events = @aircraft.downtime_events.where("started_at <= ? AND (ended_at IS NULL OR ended_at >= ?)", Time.current, Time.current)
    active_events.update_all(ended_at: Time.current)
    @aircraft.update_column(:status, "available")
    redirect_to flight_school_path(@flight_school), notice: "#{@aircraft.tail_number} marked as available."
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
