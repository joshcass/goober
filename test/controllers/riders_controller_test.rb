require 'test_helper'

class RidersControllerTest < ActionController::TestCase
  def setup
    @rider = User.create(name: "Josh",
                         email: "josh@josh.com",
                         phone_number: '5555555555',
                         password: 'password',
                         password_confirmation: 'password')
    session[:user_id] = @rider.id
  end

  test 'it creates a rider on #create' do
    post :create, user: {name: "bob",
                        email: "bob@bob.com",
                        phone_number: '5555555555',
                        password: 'password',
                        password_confirmation: 'password'}

    assert_response :redirect
    assert_redirected_to rider_path(assigns :rider)
  end
end
