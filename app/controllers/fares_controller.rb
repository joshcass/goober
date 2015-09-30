class FaresController < ApplicationController
  before_action :validate_role!
  before_action :validate_driver_has_no_rides_in_progress!, only: [:create]

  def create
    trip = Trip.find(params[:trip_id])
    trip.accepted(current_user)
    redirect_to driver_path(current_user)
  end

  def update
    trip = Trip.find(params[:trip_id])
    trip.update_status
    flash[:success] = "Trip Status Updated!"
    redirect_to driver_path(current_user)
  end

  private

  def validate_role!
    redirect_to root_path, notice: "Page Not Found" unless current_user.driver?
  end

  def validate_driver_has_no_rides_in_progress!
    redirect_to driver_path(current_user), notice: "You already have an active trip!" unless current_user.available?
  end
end
