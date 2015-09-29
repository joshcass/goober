require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @rider = User.create(name: "Josh",
                         email: "josh@josh.com",
                         phone_number: '5555555555',
                         password: 'password',
                         password_confirmation: 'password',
                         role: 'rider')
  end

  test 'it logs in a user on #create' do
    post :create, session: {email: "josh@josh.com",
                           password: 'password'}

    assert_response :redirect
    assert_redirected_to rider_path(@rider.id)
  end

  test 'it logs out a user on #destroy' do
    session[:user_id] = @rider.id
    delete :destroy
    assert_response :redirect
    assert_redirected_to root_path
    refute session[:user_id]
  end
end
