class Trip < ActiveRecord::Base
  include AASM
  COST_PER_MINUTE = 0.67

  validates :pickup_location, :dropoff_location, :passengers, presence: true
  has_one :fare
  has_one :driver, through: :fare
  has_one :ride
  has_one :rider, through: :ride
  after_create :create_trip_estimates

  enum status: %w(active accepted in_transit completed)

  scope :available_for_driver, ->(capacity) {where("status = 0 and passengers <= ?", capacity)}

  def start(rider)
    self.rider = rider
    update_rider_status
  end

  def accepted(driver)
    self.driver = driver
    update_driver_status
    self.accept!
  end

  def update_status
    case status
    when 'accepted'
      pick_up!
    when 'in_transit'
      drop_off!
    end
  end

  def estimated_cost
    estimated_time * COST_PER_MINUTE
  end

  aasm column: :status, enum: true do
    state :active, initial: true
    state :accepted
    state :in_transit
    state :completed

    event :accept do
      after do
        update_accepted_time
      end
      transitions from: :active, to: :accepted
    end

    event :pick_up do
      after do
        update_pickup_time
      end
      transitions from: :accepted, to: :in_transit
    end

    event :drop_off do
      after do
        update_dropoff_time
        update_rider_status
        update_driver_status
        calculate_cost
      end
      transitions from: :in_transit, to: :completed
    end
  end

  private

  def update_accepted_time
    update_attribute :accepted_time, Time.zone.now
  end

  def update_pickup_time
    update_attribute :pickup_time, Time.zone.now
  end

  def update_dropoff_time
    update_attribute :dropoff_time, Time.zone.now
  end

  def update_rider_status
    self.rider.update_available
  end

  def update_driver_status
    self.driver.update_available
  end

  def calculate_cost
    cost = ((dropoff_time - pickup_time) / 60) * COST_PER_MINUTE
    update_attribute(:cost, cost)
  end

  def create_trip_estimates
    directions = GoogleDirections.new(pickup_location, dropoff_location)
    unless directions.status == "NOT_FOUND"
      update_attribute(:estimated_time, directions.drive_time_in_minutes)
      update_attribute(:estimated_distance, directions.distance_in_miles)
    end
  end
end
