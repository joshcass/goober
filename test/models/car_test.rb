require 'test_helper'

class CarTest < ActiveSupport::TestCase
  test 'it is valid with proper attributes' do
    car = Car.new(make: 'tesla', model: 'X', capacity: 4)
    assert car.valid?
  end
end
