class User < ActiveRecord::Base
  has_secure_password
  validates :name, :email, :phone_number, :password, presence: true
  validates_confirmation_of :password
  validates :email, uniqueness: true
  validates_format_of :email, with: /.+@.+\..+/i

  enum role: %w(rider driver)
  has_one :car
  accepts_nested_attributes_for :car
end
