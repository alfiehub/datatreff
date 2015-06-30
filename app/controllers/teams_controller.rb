class TeamsController < ApplicationController
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

  def update
    @team = Team.find(params[:id])
    users = params[:team][:user_ids] + @team.users.pluck(:id)
    @team.update_attribute(:user_ids, users)
    redirect_to @team
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      @team.update_attribute(:user_ids, current_user.id)
      redirect_to @team, notice: "Laget ditt har blitt opprettet."
    else
      render "new"
    end
  end

  private
  def team_params
    params.require(:team).permit(:name, user_ids: [])
  end
end
