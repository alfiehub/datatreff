class CompetitionsController < ApplicationController
  before_filter :authorize_admin, only: [:new, :create]

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
    teams = competition_params[:team_ids] + @competition.teams.pluck(:id)
    team = Team.find(teams[1])

    if team.users.pluck(:id).include?(current_user.id) && @competition.update_attribute(:team_ids, teams)
      redirect_to @competition
    else
      redirect_to @competition
    end
  end

  def create
    @competition = Competition.new(competition_params)
    if @competition.save
      flash[:success] = "Du laget en ny konkurranse"
      redirect_to @competition
    else
      render "new"
    end
  end

  def competition_params
    params.require(:competition).permit(:name, :admin_name, :admin_mobile, :admin_email, :start_time, team_ids: [])
  end
end
