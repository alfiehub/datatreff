class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(session[:user_id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "Du har blitt registrert."
    else
      render "new"
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :name, :mobile, :email, :password, :password_confirmation)
  end
end
