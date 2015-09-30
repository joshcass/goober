require 'test_helper'

class TripTest < ActiveSupport::TestCase
  def rider
    @rider ||= User.create(email: 'joe@joe.com', name: 'joe', phone_number: '555-1212', password: 'password', password_confirmation: 'password', role: 'rider')
  end

  def driver
    @driver ||= User.create(email: 'joe@joe.com', name: 'joe', phone_number: '555-1212', password: 'password', password_confirmation: 'password', role: 'driver')
  end

  def trip
    @trip ||= Trip.create(pickup_location: '111 Street', dropoff_location: '222 Street', passengers: '5')
  end

  test 'it is valid with proper attributes' do
    trip = Trip.new(pickup_location: '111 Street', dropoff_location: '222 Street', passengers: '5')
    assert trip.valid?
  end

  test 'it has initial status of active' do
    assert_equal trip.status, 'active'
  end

  test 'it can have a rider' do
    trip.rider = rider
    assert_equal trip.rider, rider
  end

  test 'it can have a driver' do
    trip.driver = driver
    assert_equal trip.driver, driver
  end

  test 'trip start adds rider and changes rider status' do
    trip.start(rider)
    assert_equal trip.rider, rider
    refute rider.available?
  end
end
