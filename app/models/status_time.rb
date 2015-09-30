class StatusTime
  include ActionView::Helpers::DateHelper

  def self.time(trip)
    case trip.status
    when 'active'
      trip.created_at
    when 'accepted'
      trip.accepted_time
    when 'in_transit'
      trip.pickup_time
    when 'completed'
      trip.dropoff_time
    end
  end
end
