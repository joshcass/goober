class StatusController < ApplicationController

  def index
    trip = Trip.find(params[:trip_id])
    render json: {status: trip.status.titleize, time: format_time(StatusTime.time(trip))}
  end

  def format_time(time)
    time.strftime("%b %-d, %Y %-l:%M %p")
  end
end
