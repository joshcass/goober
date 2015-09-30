require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def rider
    @rider ||= User.create(email: 'joe@joe.com', name: 'joe', phone_number: '555-1212', password: 'password', password_confirmation: 'password', role: 'rider')
  end

  def driver
    @driver ||= User.create(email: 'joe@joe.com', name: 'joe', phone_number: '555-1212', password: 'password', password_confirmation: 'password', role: 'driver')
  end

  def trip
    @trip ||= Trip.create(pickup_location: '111 Street', dropoff_location: '222 Street', passengers: '5')
  end

  def inactive_trip
    @inactive_trip ||= Trip.create(pickup_location: '333 Street', dropoff_location: '444 Street', passengers: '5', status: 'completed')
  end

  test 'a user is valid with proper attributes' do
    user = User.new(email: 'joe@joe.com', name: 'joe', phone_number: '555-1212', password: 'password', password_confirmation: 'password')
    assert user.valid?
  end

  test 'a users default state is avaliable' do
    user = User.new(email: 'joe@joe.com', name: 'joe', phone_number: '555-1212', password: 'password', password_confirmation: 'password')
    assert user.available?
  end

 test 'a user who is a rider can have a ride' do
   rider.rides.create(trip_id: trip.id)
   assert_equal rider.rides.count, 1
  end

 test 'a user who is a driver can have a fare' do
   driver.fares.create(trip_id: trip.id)
   assert_equal driver.fares.count, 1
 end

 test 'a user who is a rider can have an active ride' do
   trip.rider = rider
   inactive_trip.rider = rider
   assert_equal rider.active_ride, trip.ride
 end

 test 'a user who is a driver can have an active fare' do
   trip.driver = driver
   inactive_trip.driver = driver
   assert_equal driver.active_fare, trip.fare
 end
end
