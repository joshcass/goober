require 'test_helper'

class TripsControllerTest < ActionController::TestCase
  def setup
    @rider = User.create(name: "Josh",
                         email: "josh@josh.com",
                         phone_number: '5555555555',
                         password: 'password',
                         password_confirmation: 'password')
    session[:user_id] = @rider.id
  end

  test 'it creates a trip on #create' do
    post :create, trip: {pickup_location: "111 street",
                         dropoff_location: "222 street",
                         passengers: '5'}

    assert_response :redirect
    assert_redirected_to rider_path(@rider.id)
    assert 1, Trip.all.count
  end

  test 'it can load #new' do
    get :new
    assert_response :success
    assert_not_nil assigns :trip
    assert_template :new
  end
end
