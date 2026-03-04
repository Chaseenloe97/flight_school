class MaintenanceLogsController < ApplicationController
  before_action :require_login
  before_action :set_flight_school_and_aircraft
  before_action :set_maintenance_log, only: %i[edit update destroy]

  def new
    @maintenance_log = @aircraft.maintenance_logs.build(logged_at: Time.current)
  end

  def create
    @maintenance_log = @aircraft.maintenance_logs.build(maintenance_log_params)
    if @maintenance_log.save
      redirect_to flight_school_aircraft_path(@flight_school, @aircraft), notice: "Maintenance log added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @maintenance_log.update(maintenance_log_params)
      redirect_to flight_school_aircraft_path(@flight_school, @aircraft), notice: "Maintenance log updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @maintenance_log.destroy
    redirect_to flight_school_aircraft_path(@flight_school, @aircraft), notice: "Maintenance log deleted."
  end

  private

  def set_flight_school_and_aircraft
    @flight_school = current_user.flight_schools.find(params[:flight_school_id])
    @aircraft = @flight_school.aircrafts.find(params[:aircraft_id])
  end

  def set_maintenance_log
    @maintenance_log = @aircraft.maintenance_logs.find(params[:id])
  end

  def maintenance_log_params
    params.require(:maintenance_log).permit(:logged_at, :log_type, :hobbs_hours, :tach_hours, :notes)
  end
end
