class RidersController < ApplicationController
  skip_before_action :authorize!, only: [:new, :create]
  before_action :validate_role!, only: [:show]

  def show
    @rider = current_user
    @active_ride = @rider.active_ride
  end

  def new
    @rider = User.new(role: 'rider')
  end

  def create
    @rider = User.new(valid_params.merge(role: 'rider'))
    if @rider.save
      session[:user_id] = @rider.id
      redirect_to rider_path @rider
    else
      flash.now[:alert] = @rider.errors.full_messages.join(", ")
      render :new
    end
  end

  private

  def valid_params
    params.require(:user).permit(:name, :email, :phone_number, :password, :password_confirmation)
  end

  def validate_role!
    redirect_to root_path, notice: "Page Not Found" unless current_user.rider?
  end
end
