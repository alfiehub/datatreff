class CompetitionsController < ApplicationController
  before_filter :authorize_admin, only: [:new, :create]

  def index
    @competitions = Competition.all
  end

  def show
    @competition = Competition.find(params[:id])
    if @competition.started
      redirect_to started_competition_path(@competition)
    end
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

    # Generate the rest of winner bracket
    size /= 2
    round = 2
    while size >= 2
      Matchup.generate_matches(round, false, [], size, id)
      round += 1
      size /= 2
    end

    # Generate grand final

    Matchup.generate_matches(round, false, [], 2, id)

    # Generate lower bracket
    round = 1
    size = (2 ** ((Math::log(teams.length) / Math::log(2)).to_f).ceil)/2
    while size >= 2
      Matchup.generate_matches(round, true, [], size, id)
      round += 1
      size /= 2
    end


    @competition.update_attribute(:started, true)
    flash[:success] = "Du har startet konkurransen!"
    redirect_to @competition
  end

  def started
    @competition = Competition.find(params[:id])
    if !@competition.started
      redirect_to @competition
    end
    @matches = Competition.find(params[:id]).matchups
    puts "LOL"
    puts @matches
  end

  def competition_params
    params.require(:competition).permit(:name, :admin_name, :admin_mobile, :admin_email, :start_time, team_ids: [])
  end
end
