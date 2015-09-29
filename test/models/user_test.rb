require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'a user is valid with proper attributes' do
    user = User.new(email: 'joe@joe.com', name: 'joe', phone_number: '555-1212', password: 'password', password_confirmation: 'password')
    assert user.valid?
  end
end
