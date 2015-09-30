class Trip < ActiveRecord::Base
  validates :pickup_location, :dropoff_location, :passengers, presence: true
  has_one :fare
  has_one :driver, through: :fare
  has_one :ride
  has_one :rider, through: :ride

  enum status: %w(active accepted in_transit completed)

  def start(rider)
    self.rider = rider
    rider.update_available
  end
end
