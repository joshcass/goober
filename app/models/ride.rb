class Ride < ActiveRecord::Base
  belongs_to :rider, -> {where(role: 'rider')}, class_name: User
  belongs_to :trip
end
