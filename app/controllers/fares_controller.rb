class FaresController < ApplicationController
  before_action :validate_role!, :validate_driver_has_no_rides_in_progress!

  def create
    trip = Trip.find(params[:trip_id])
    trip.accepted(current_user)
    redirect_to driver_path(current_user)
  end

  private

  def validate_role!
    redirect_to root_path, notice: "Page Not Found" unless current_user.driver?
  end

  def validate_driver_has_no_rides_in_progress!
    redirect_to driver_path(current_user) unless current_user.available?
  end
end
