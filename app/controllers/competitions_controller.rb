class CompetitionsController < ApplicationController
  before_filter :authorize_admin, only: [:new, :create, :edit, :start, :all]
  before_filter :authorize, except: [:started, :matches, :show]

  helper_method :is_participating?

  def index
    @competitions = Competition.all
  end

  def show
    @competition = Competition.find(params[:id])
    if @competition.started
      redirect_to started_competition_path(@competition)
    elsif current_user.nil?
      render :public
    end
  end

  def all
    @competition = Competition.find(params[:id])
  end

  def new
    @competition = Competition.new
  end

  def edit
    @competition = Competition.find(params[:id])
  end

  def update
    @competition = Competition.find(params[:id])
    team_ids = (competition_params[:team_ids].nil? || competition_params[:team_ids].size == 0) ? [] : competition_params[:team_ids]
    teams = team_ids + @competition.teams.pluck(:id)
    team = (teams.size == @competition.teams.size) ? nil : Team.find_by_id(teams[0])

    if is_admin? && @competition.update_attributes(competition_params)
      @competition.update_attribute(:team_ids, teams)
      flash[:success] = "Du endret konkurransen."
      redirect_to @competition
    elsif !team.nil? && teams.size-1 == @competition.teams.size && team.users.pluck(:id).include?(current_user.id) && team.users.size >= @competition.team_size && !check_if_anyone_in_team_is_already_participating(@competition, team) && @competition.update_attribute(:team_ids, teams)
      flash[:success] = "Laget ditt ble meldt på!"
      redirect_to @competition
    elsif team.nil? && !@competition.users.pluck(:id).include?(current_user.id)
      flash[:danger] = "Du har ikke valgt noe lag, har du husket å opprette ett? Gå til ditt navn (øverst i høyre hjørnet) også til Mine lag for en oversikt."
      redirect_to @competition
    else
      flash[:danger] = "Noe gikk galt, enten du eller noen andre på laget ditt deltar allerede i konkurransen. Er du sikker på at det er nok medlemmer på laget ditt?"
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
    pre_seeded_teams = @competition.team_seeds.pluck(:team_name)
    used_positions = @competition.team_seeds.pluck(:seed)

    # Shuffle and create team seeds
    t_arr = []
    teams.each do |t|
      t_arr.push(t.name)
    end
    while t_arr.size < 2 ** (Math.log(t_arr.size)/Math.log(2)).ceil do
      t_arr.push('__')
    end

    shuffled = t_arr.shuffle

    # Remove the teams already seeded from the shuffled array
    pre_seeded_teams.each do |p|
      shuffled.delete(p)
    end

    # Create team seeds, increment position if its already used, else: create a new TeamSeed
    position = 0
    while shuffled.length > 0 do
      if !used_positions.include?(position)
        team = shuffled.pop()
        TeamSeed.new(team_name: team, competition_id: id, seed: position).save
      end
      position += 1
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
  end

  def matches
    @matches = Competition.find(params[:id]).team_seeds.order(:seed)
    @results = Competition.find(params[:id]).results.accepted
    respond_to do |f|
      f.json { render :json => {teams: @matches, results: @results} }
    end
  end

  def is_participating?(c_id, user_id)
    users = Competition.find(c_id).users.pluck(:id)

    return users.include?(user_id)
  end

  private
  def competition_params
    params.require(:competition).permit(:name, :description, :admin_name, :admin_email, :admin_mobile, :start_time, :team_size, team_ids: [])
  end

  private
  def check_if_anyone_in_team_is_already_participating(competition, team)
    team.users.each do |u|
      if competition.users.include?(u)
        return true
      end
    end
    return false
  end
end
