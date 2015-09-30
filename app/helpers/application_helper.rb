module ApplicationHelper

  def button_class(user)
    user.available? ? "button" : "button secondary disabled"
  end

  def fare_button_display(fare)
    display = trip_statuses[fare.trip.status]
    link_to display, trip_fare_path(fare.trip, fare), method: :patch, class: 'button small'
  end

  def trip_statuses
    {'active' => 'Picked Up',
      'in_transit' => 'Dropped Off'}
  end
end
