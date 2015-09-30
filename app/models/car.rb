class Car < ActiveRecord::Base
  validates :make, :model, :capacity, presence: true
  belongs_to :user

  def type
    make + " " + model
  end
end
