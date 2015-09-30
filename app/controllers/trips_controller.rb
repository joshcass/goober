class TripsController < ApplicationController
  before_action :validate_rider_has_no_rides_in_progress!

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new valid_params
    if @trip.save
      @trip.start(current_user)
      redirect_to rider_path(current_user)
    else
      flash.now[:alert] = @trip.errors.full_messages.join(", ")
      render :new
    end
  end

  private

  def valid_params
    params.require(:trip).permit(:pickup_location, :dropoff_location, :passengers)
  end

  def validate_rider_has_no_rides_in_progress!
    redirect_to rider_path(current_user) unless current_user.available?
  end
end
