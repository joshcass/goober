class DriversController < ApplicationController
  skip_before_action :authorize!, only: [:new, :create]
  before_action :verify_role!, only: [:show]

  def show
    @driver = current_user
    @available_trips = Trip.available_for_driver(@driver.car.capacity)
  end

  def new
    @driver = User.new(role: 'driver')
    @driver.car = @driver.build_car
  end

  def create
    @driver = User.new(valid_params.merge(role: 'driver'))
    if @driver.save
      session[:user_id] = @driver.id
      redirect_to driver_path @driver
    else
      flash.now[:alert] = @driver.errors.full_messages.join(", ")
      render :new
    end
  end

  private

  def valid_params
    params.require(:user).permit(:name, :email, :phone_number, :password, :password_confirmation, :car_attributes => [:make, :model, :capacity])
  end

  def verify_role!
    redirect_to root_path, notice: "Page Not Found" unless current_user.driver?
  end
end
