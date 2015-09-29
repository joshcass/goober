require 'test_helper'

class DriversControllerTest < ActionController::TestCase
  def setup
    @driver = User.create(name: "Josh",
                         email: "josh@josh.com",
                         phone_number: '5555555555',
                         password: 'password',
                         password_confirmation: 'password')
    @driver.car = Car.create(make: "Tesla", model: "X", capacity: 5)
    session[:user_id] = @driver.id
  end

  test 'it creates a driver on #create' do
    post :create, user: {name: "bob",
                        email: "bob@bob.com",
                        phone_number: '5555555555',
                        password: 'password',
                        password_confirmation: 'password',
                        car_attributes: {make: 'Tesla', model: 'X', capacity: 5}}

    assert_response :redirect
    assert_redirected_to driver_path(assigns :driver)
  end
end
