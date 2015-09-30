require 'test_helper'

class DriversControllerTest < ActionController::TestCase
  def setup
    @driver = User.create(name: "Josh",
                         email: "josh@josh.com",
                         phone_number: '5555555555',
                         password: 'password',
                         password_confirmation: 'password',
                         role: 'driver')
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

  test 'it can load #new' do
    get :new
    assert_response :success
    assert_not_nil assigns :driver
    assert_template :new
  end

  test 'it can load #show' do
    get :show, id: @driver.id
    assert_response :success
    assert_not_nil assigns :driver
    assert_not_nil assigns :available_trips
    assert_template :show
  end

  test 'a rider cannot view driver show' do
     @rider = User.create(name: "Josh",
                         email: "jo@jo.com",
                         phone_number: '5555555555',
                         password: 'password',
                         password_confirmation: 'password',
                         role: 'rider')
     session[:user_id] = @rider.id

     get :show, id: @driver.id
     assert_response :redirect
     assert_redirected_to root_path
  end
end
