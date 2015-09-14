class SessionsController < ApplicationController
  def new
  end

  def create
    user = (User.find_by_username(params[:user][:username]) || User.find_by_email(params[:user][:username].downcase)) if !params[:user][:username].nil?

    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      flash[:success] = "Velkommen tilbake, #{user.username}!"
      redirect_to root_path
    else
      flash.now[:danger] = "Brukernavnet/e-posten eller passordet er ugyldig."
      render :new
    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, flash: {success: "Du ble logget ut!"}
  end
end
