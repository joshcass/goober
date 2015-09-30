class Fare < ActiveRecord::Base
  belongs_to :driver, -> {where(role: 1)}, class_name: User
  belongs_to :trip
end
