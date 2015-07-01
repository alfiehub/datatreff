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

  def start
    @competition = Competition.find(params[:id])
    id = params[:id]
    teams = @competition.teams
    # Some math to calculate the least amount of matches needed for the first round
    size = 2 ** ((Math::log(teams.length) / Math::log(2)).to_f).ceil

    # Create first round winners
    # generate_matches(round, lower, teams, size, comp_id)
    Matchup.generate_matches(1, false, teams, size, id)
    next_round_winner_teams = size/2
    round = 2
    while next_round_winner_teams > 1
      Matchup.generate_matches(round, false, [], next_round_winner_teams, id)
      round += 1
      next_round_winner_teams /= 2
    end
    @competition.update_attribute(:started, true)
    flash[:success] = "Du har startet konkurransen!"
    redirect_to @competition
  end

  def competition_params
    params.require(:competition).permit(:name, :admin_name, :admin_mobile, :admin_email, :start_time, team_ids: [])
  end
end
