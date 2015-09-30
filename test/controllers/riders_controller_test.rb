require 'test_helper'

class RidersControllerTest < ActionController::TestCase
  def setup
    @rider = User.create(name: "Josh",
                         email: "josh@josh.com",
                         phone_number: '5555555555',
                         password: 'password',
                         password_confirmation: 'password',
                         role: 'rider')
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

  test 'it can load #new' do
    get :new
    assert_response :success
    assert_not_nil assigns :rider
    assert_template :new
  end

  test 'it can load #show' do
    get :show, id: @rider.id
    assert_response :success
    assert_not_nil assigns :rider
    assert_template :show
  end

  test 'a driver cannot view rider show' do
     @driver = User.create(name: "Josh",
                         email: "jo@jo.com",
                         phone_number: '5555555555',
                         password: 'password',
                         password_confirmation: 'password',
                         role: 'driver')
     session[:user_id] = @driver.id

     get :show, id: @rider.id
     assert_response :redirect
     assert_redirected_to root_path
  end
end
