class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_username(params[:user][:username])

    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      flash[:success] = "Du ble logget inn som #{user.username}!"
      redirect_to root_path
    else
      flash[:danger] = "Brukernavnet eller passordet er ugyldig."
      render :new
    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, flash: {success: "Du er blitt logget ut!"}
  end
end
