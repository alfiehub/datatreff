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
      redirect_to teams_path
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if params[:team][:name].nil?
      users = params[:team][:user_ids] + @team.users.pluck(:id)
      @team.update_attribute(:user_ids, users)
      flash[:success] = "Du la til en bruker!"
    else
      @team.update_attribute(:name, params[:team][:name])
      flash[:success] = "Du endret navnet til laget!"
    end
    redirect_to @team
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
    params.require(:team).permit(:name, user_ids: [])
  end
end
