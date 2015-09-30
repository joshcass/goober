class Ride < ActiveRecord::Base
  belongs_to :rider, -> {where(role: 0)}, class_name: User
  belongs_to :trip
end
