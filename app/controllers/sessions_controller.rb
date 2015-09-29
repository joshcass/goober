class SessionsController < ApplicationController
  skip_before_action :authorize!

  def new
  end

  def create
    user = User.find_by(email: valid_params[:email])
    if user && user.authenticate(valid_params[:password])
      session[:user_id] = user.id
      user.driver? ? redirect_to(driver_path user) : redirect_to(rider_path user)
    else
      flash.now[:alert] = "Login failed"
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  private

  def valid_params
    params.require(:session).permit(:email, :password)
  end

end
