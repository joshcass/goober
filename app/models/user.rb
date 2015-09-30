class User < ActiveRecord::Base
  has_secure_password
  validates :name, :email, :phone_number, :password, presence: true
  validates_confirmation_of :password
  validates :email, uniqueness: true
  validates_format_of :email, with: /.+@.+\..+/i

  enum role: %w(rider driver)
  has_one :car
  accepts_nested_attributes_for :car
  has_many :fares, foreign_key: :driver_id
  has_many :driver_trips, through: :fares, source: 'trip'
  has_many :rides, foreign_key: :rider_id
  has_many :rider_trips, through: :rides, source: 'trip'


  def update_available
    available? ? update_attribute(:available, false) : update_attribute(:available, true)
  end

  def active_ride
    rides.joins(:trip).where('trips.status != ?', 3).first
  end

  def active_fare
    fares.joins(:trip).where('trips.status != ?', 3).first
  end

  def completed_driver_trips
    driver_trips.where(status: 3)
  end

  def completed_rider_trips
    rider_trips.where(status: 3)
  end
end
