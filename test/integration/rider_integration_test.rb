require 'test_helper'

class RiderIntegrationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  def setup
    Capybara.app = Goober::Application
    Trip.skip_callback(:create, :after, :create_trip_estimates)
  end

  def teardown
    Trip.set_callback(:create, :after, :create_trip_estimates)
  end

  def rider
    @rider ||= User.create(email: 'joe@joe.com', name: 'joe', phone_number: '555-1212', password: 'password', password_confirmation: 'password', role: 'rider')
  end

  def login_as(user)
    visit root_path
    click_on 'Login'
    fill_in :session_email, with: user.email
    fill_in :session_password, with: user.password
    click_on 'Login Now'
  end

  test 'rider can create an account' do
    visit root_path
    click_on 'Rider'
    fill_in :user_name, with: 'Joe'
    fill_in :user_email, with: 'joe@joe.com'
    fill_in :user_phone_number, with: '5555555555'
    fill_in :user_password, with: 'password'
    fill_in :user_password_confirmation, with: 'password'
    click_on 'Create Account'

    rider = User.first
    assert_equal 1, User.count
    assert_equal rider_path(rider), current_path
  end

  test 'registered rider can log in' do
    visit root_path
    click_on 'Login'
    fill_in :session_email, with: rider.email
    fill_in :session_password, with: rider.password
    click_on 'Login Now'

    assert_equal rider_path(rider), current_path
    assert page.has_content? 'Start A Trip'
  end

  test 'logged in rider can start a trip' do
    Trip.set_callback(:create, :after, :create_trip_estimates)
    VCR.use_cassette('create_trip') do
      login_as(rider)
      click_on 'Start A Trip'
      fill_in :trip_pickup_location, with: '196 S Corona St Denver CO'
      fill_in :trip_dropoff_location, with: '1510 Blake St Denver CO'
      fill_in :trip_passengers, with: 2
      click_on 'Request A Driver'

      assert_equal rider_path(rider), current_path
      assert page.has_content? 'Current Trip'
      assert page.has_content? 'Dropoff Location: 1510 Blake St Denver CO'
      assert page.has_content? 'Estimated Trip Distance: 4 miles'
      assert page.has_content? 'Status: Active'
    end
  end
end
