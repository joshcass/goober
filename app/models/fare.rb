class Fare < ActiveRecord::Base
  belongs_to :driver, -> {where(role: 'driver')}, class_name: User
  belongs_to :trip
end
