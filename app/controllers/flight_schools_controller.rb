class FlightSchoolsController < ApplicationController
  before_action :require_login
  before_action :set_flight_school, only: %i[show edit update destroy]

  def index
    @flight_schools = current_user.flight_schools
  end

  def show
    @aircrafts = @flight_school.aircrafts.includes(:downtime_events)
  end

  def new
    @flight_school = current_user.flight_schools.build
  end

  def create
    @flight_school = current_user.flight_schools.build(flight_school_params)
    if @flight_school.save
      redirect_to @flight_school, notice: "Flight school created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @flight_school.update(flight_school_params)
      redirect_to @flight_school, notice: "Flight school updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @flight_school.destroy
    redirect_to flight_schools_path, notice: "Flight school deleted."
  end

  private

  def set_flight_school
    @flight_school = current_user.flight_schools.find(params[:id])
  end

  def flight_school_params
    params.require(:flight_school).permit(:name, :location)
  end
end
