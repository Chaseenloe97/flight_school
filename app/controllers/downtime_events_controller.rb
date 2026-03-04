class DowntimeEventsController < ApplicationController
  before_action :require_login
  before_action :set_flight_school_and_aircraft
  before_action :set_downtime_event, only: %i[edit update destroy]

  def new
    @downtime_event = @aircraft.downtime_events.build(started_at: Time.current)
  end

  def create
    @downtime_event = @aircraft.downtime_events.build(downtime_event_params)
    @downtime_event.created_by = current_user
    if @downtime_event.save
      redirect_to flight_school_aircraft_path(@flight_school, @aircraft), notice: "Downtime event logged."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @downtime_event.update(downtime_event_params)
      redirect_to flight_school_aircraft_path(@flight_school, @aircraft), notice: "Downtime event updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @downtime_event.destroy
    redirect_to flight_school_aircraft_path(@flight_school, @aircraft), notice: "Downtime event deleted."
  end

  private

  def set_flight_school_and_aircraft
    @flight_school = current_user.flight_schools.find(params[:flight_school_id])
    @aircraft = @flight_school.aircrafts.find(params[:aircraft_id])
  end

  def set_downtime_event
    @downtime_event = @aircraft.downtime_events.find(params[:id])
  end

  def downtime_event_params
    params.require(:downtime_event).permit(:started_at, :ended_at, :reason_type, :description)
  end
end
