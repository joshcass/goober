require 'test_helper'

class TripTest < ActiveSupport::TestCase
  def rider
    @rider ||= User.create(email: 'joe@joe.com', name: 'joe', phone_number: '555-1212', password: 'password', password_confirmation: 'password', role: 'rider')
  end

  def driver
    @driver ||= User.create(email: 'joe@joe.com', name: 'joe', phone_number: '555-1212', password: 'password', password_confirmation: 'password', role: 'driver')
  end

  def trip
    @trip ||= Trip.create(pickup_location: '111 Street', dropoff_location: '222 Street', passengers: 5)
  end

  test 'it is valid with proper attributes' do
    trip = Trip.new(pickup_location: '111 Street', dropoff_location: '222 Street', passengers: 5)
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

  test 'it can find available trips for a driver' do
    trip
    Trip.create(pickup_location: '333 Street', dropoff_location: '444 Street', passengers: 15)
    Trip.create(pickup_location: '333 Street', dropoff_location: '444 Street', passengers: 5, status: 'in_transit')
    driver.car = Car.create(make: "Tesla", model: 'X', capacity: 7)
    assert_equal Trip.available_for_driver(driver.car.capacity).count, 1
  end

  test 'trip accepted adds driver changes driver status and trip status' do
    trip.accepted(driver)
    assert_equal trip.driver, driver
    assert_equal trip.status, 'accepted'
    refute driver.available?
  end

  test 'it can transition from active to accepted and update accepted time' do
    trip.accept!
    assert_equal trip.status, 'accepted'
    assert_not_nil trip.accepted_time
  end

  test 'it can transition from accepted to in_tranist and update pickup time' do
    trip.accept!
    trip.pick_up!
    assert_equal trip.status, 'in_transit'
    assert_not_nil trip.pickup_time
  end

  test 'it can transiion from in_transit to completed and update dropoff time' do
    trip.accept!
    trip.pick_up!
    trip.drop_off!
    assert_equal trip.status, 'completed'
    assert_not_nil trip.dropoff_time
  end
end
