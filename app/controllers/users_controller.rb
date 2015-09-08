class UsersController < ApplicationController
  before_filter :authorize_admin, only: [:index, :show, :destroy]
  before_filter :authorize, only: [:edit, :update]

  def index
    @users = User.all.order(:created_at)
  end

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
      flash.now[:danger] = "Noe gikk galt."
      render :new
    end
  end

  def edit
    @user = params[:id].nil? ? User.find(current_user.id) : User.find(params[:id])
    if !(is_admin? || @user.id == current_user.id)
      flash[:danger] = "Du har ikke tillatelse til dette."
      redirect_to root_path
    end
  end

  def update
    @user = User.find(params[:id])
    if is_admin? && @user.update_attributes(admin_user_params)
      flash[:success] = "Du endret brukeren."
      redirect_to edit_user_path(@user)
    elsif current_user.id == @user.id && @user.update_attributes(user_params)
      flash[:success] = "Du endret brukeren din."
      redirect_to edit_user_path(@user)
    else
      flash.now[:danger] = "Noe gikk galt."
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "Du slettet brukeren."
    else
      flash[:warning] = "Noe gikk galt."
    end
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(:username, :name, :mobile, :email, :password, :password_confirmation)
  end

  private
  def admin_user_params
    params.require(:user).permit(:username, :name, :mobile, :email, :password, :password_confirmation, :admin)
  end
end
