require 'test_helper'

class FaresControllerTest < ActionController::TestCase
  def setup
    @driver = User.create(name: "Josh",
                         email: "josh@josh.com",
                         phone_number: '5555555555',
                         password: 'password',
                         password_confirmation: 'password',
                         role: 'driver')
    @driver.car = Car.create(make: "Tesla", model: "X", capacity: 5)
    @trip = Trip.create(pickup_location: '111 Street', dropoff_location: '222 Street', passengers: 5)

    session[:user_id] = @driver.id
  end

  test 'it creates a fare on #create' do
    post :create, trip_id: @trip.id
    assert_response :redirect
    assert_redirected_to driver_path(@driver.id)
  end
end
