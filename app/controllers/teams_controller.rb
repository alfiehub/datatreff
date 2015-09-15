class TeamsController < ApplicationController
  before_filter :authorize
  def index
    if is_admin?
      @teams = Team.all
    else
      @teams = current_user.teams
    end
  end

  def new
    @team = Team.new
  end

  def show
    @team = Team.find(params[:id])
    if !is_admin? && (current_user.nil? || !current_user.teams.include?(@team))
      flash[:danger] = "Du får ikke lov til å gjøre dette"
      redirect_to teams_path
    end
  end

  def edit
    @team = Team.find(params[:id])
    if !@team.users.pluck(:id).include?(current_user.id)
      flash[:danger] = "Du har ikke tillatelse til å gjøre dette, hvorfor prøver du? :'("
      redirect_to root_path
    end
  end

  def update
    @team = Team.find(params[:id])
    if params[:team][:name].nil?
      user = User.find_by_username(params[:team][:username])

      if user.nil?
        flash[:danger] = params[:team][:username] + ' finnes ikke i databasen :('
        redirect_to @team
      else
        if !@team.users.pluck(:id).include?(user.id) && UserTeam.new(user_id: user.id, team_id: @team.id).save()
          flash[:success] = "Du la til " + params[:team][:username] + '!'
          redirect_to @team
        else
          flash[:danger] = 'Noe gikk galt, er brukeren allerede lagt til?'
          redirect_to @team
        end
      end
    elsif (@team.users.pluck(:id).include?(current_user.id) || is_admin? )&& @team.update_attributes(team_params)
      flash[:success] = "Du endret navnet til laget!"
      redirect_to @team
    elsif !@team.users.pluck(:id).include?(current_user.id)
      flash[:danger] = "Ayyyy lmao, du kan ikke gjøre dette lenger ditt troll!"
      redirect_to root_path
    else
      flash.now[:danger] = "Noe gikk galt."
      render :edit
    end
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      @team.update_attribute(:user_ids, current_user.id)
      flash[:success] = "Du har opprettet et nytt lag!"
      redirect_to @team
    else
      render "new"
    end
  end

  private
  def team_params
    params.require(:team).permit(:name)
  end
end
