require 'test_helper'

class DriverIntegrationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  def setup
    Capybara.app = Goober::Application
    Trip.skip_callback(:create, :after, :create_trip_estimates)
    @trip = Trip.create(pickup_location: '111 Street', dropoff_location: '222 Street', passengers: '5')
    @trip.rider = User.create(email: 'jimmy@jimmybob.com', name: 'joe', phone_number: '555-1212', password: 'password', password_confirmation: 'password', role: 'rider')
  end

  def teardown
    Trip.set_callback(:create, :after, :create_trip_estimates)
  end

  def driver
    @driver ||= User.create(email: 'joe@joe.com', name: 'joe', phone_number: '555-1212', password: 'password', password_confirmation: 'password', role: 'driver')
  end

  def login_as(user)
    visit root_path
    click_on 'Login'
    fill_in :session_email, with: user.email
    fill_in :session_password, with: user.password
    click_on 'Login Now'
  end

  test 'driver can create an account' do
    visit root_path
    click_on 'Driver'
    fill_in :user_name, with: 'Joe'
    fill_in :user_email, with: 'joe@joe.com'
    fill_in :user_phone_number, with: '5555555555'
    fill_in :user_password, with: 'password'
    fill_in :user_password_confirmation, with: 'password'
    fill_in :user_car_attributes_make, with: 'Tesla'
    fill_in :user_car_attributes_model, with: 'X'
    fill_in :user_car_attributes_capacity, with: 7
    click_on 'Create Account'

    driver = User.last
    assert_equal 2, User.count
    assert_equal driver_path(driver), current_path
  end

  test 'registered driver can log in' do
    driver.car = Car.create(make: "Tesla", model: "X", capacity: 7)

    visit root_path
    click_on 'Login'
    fill_in :session_email, with: driver.email
    fill_in :session_password, with: driver.password
    click_on 'Login Now'

    assert_equal driver_path(driver), current_path
  end

  test 'driver can accept a ride' do
    driver.car = Car.create(make: "Tesla", model: "X", capacity: 7)
    login_as(driver)
    click_on 'Pickup Rider'

    assert_equal driver_path(driver), current_path
    assert page.has_content? 'Current Trip'
    assert page.has_content? 'Dropoff Location: 222 Street'
    assert page.has_content? 'Status: Accepted'
    assert page.has_button? 'Picked Up'
  end

  test 'driver can pick up a ride' do
    driver.car = Car.create(make: "Tesla", model: "X", capacity: 7)
    @trip.driver = driver
    login_as(driver)
    click_on 'Pickup Rider'
    click_on 'Picked Up'

    assert_equal driver_path(driver), current_path
    assert page.has_content? 'Current Trip'
    assert page.has_content? 'Dropoff Location: 222 Street'
    assert page.has_content? 'Status: In Transit'
    assert page.has_button? 'Dropped Off'
  end

  test 'driver can drop off a ride' do
    driver.car = Car.create(make: "Tesla", model: "X", capacity: 7)
    @trip.driver = driver
    login_as(driver)
    click_on 'Pickup Rider'
    click_on 'Picked Up'
    click_on 'Dropped Off'

    assert_equal driver_path(driver), current_path
    assert page.has_content? 'Trip Requests'
    assert page.has_content? 'Completed Rides'
  end

end
