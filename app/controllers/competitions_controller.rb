class CompetitionsController < ApplicationController
  def index
    @competitions = Competition.all
  end

  def show
    @competition = Competition.find(params[:id])
  end

  def new
    @competition = Competition.new
  end

  def update
    @competition = Competition.find(params[:id])
    teams = competition_params[:team_ids]
    team = Team.find(teams[1])
    puts teams
    if teams.length <= 2 && @competition.update_attributes(competition_params) && team.users.pluck(:id).include?(current_user.id)
      redirect_to @competition
    else
      redirect_to @competition
    end
  end

  def create
    @competition = Competition.new(competition_params)
    if @competition.save
      redirect_to root_path, notice: "Du har laget en ny konkurranse."
    else
      render "new"
    end
  end
  def competition_params
    params.require(:competition).permit(:name, :admin_name, :admin_mobile, :admin_email, :start_time, team_ids: [])
  end
end
