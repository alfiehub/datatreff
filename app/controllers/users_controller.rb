class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if @user.id == 1
        @user.update_attribute(:admin, true)
      end
      session[:user_id] = @user.id
      flash[:success] = "Du er blitt registrert og logget inn!"
      redirect_to root_path
    else
      render "new"
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :name, :mobile, :email, :password, :password_confirmation)
  end
end
