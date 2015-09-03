class CompetitionsController < ApplicationController
  before_filter :authorize_admin, only: [:new, :create, :edit, :update]

  helper_method :is_participating?

  def index
    @competitions = Competition.all
  end

  def show
    @competition = Competition.find(params[:id])
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, tables: true)
    if @competition.started
      redirect_to started_competition_path(@competition)
    elsif current_user.nil?
      flash[:warning] = "Konkurransen har ikke started enda, du må logge inn for å melde deg på."
      redirect_to logg_inn_path
    end
  end

  def new
    @competition = Competition.new
  end

  def edit
    @competition = Competition.find(params[:id])
  end

  def update
    @competition = Competition.find(params[:id])
    team_ids = (competition_params[:team_ids].nil?) ? [] : competition_params[:team_ids]
    teams = team_ids + @competition.teams.pluck(:id)
    team = (teams.length == @competition.teams.length) ? nil : Team.find(teams[1])

    if is_admin? && @competition.update_attributes(competition_params)
      @competition.update_attribute(:team_ids, teams)
      flash[:success] = "Du endret konkurransen."
      redirect_to @competition
    elsif !team.nil? && team.users.pluck(:id).include?(current_user.id) && team.users.length >= @competition.team_size && !check_if_anyone_in_team_is_already_participating(@competition, team) && @competition.update_attribute(:team_ids, teams)
      flash[:success] = "Laget ditt ble meldt på!"
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

    # Shuffle and create team seeds
    t_arr = []
    teams.each do |t|
      t_arr.push(t.name)
    end
    while t_arr.length < 2 ** (Math.log(t_arr.length)/Math.log(2)).ceil do
      t_arr.push('__')
    end

    shuffled = t_arr.shuffle

    (0..shuffled.length-1).each do |i|
      TeamSeed.new(team_name: shuffled[i], competition_id: id, seed: i).save
    end

    @competition.update_attribute(:started, true)
    flash[:success] = "Du har startet konkurransen!"
    redirect_to @competition
  end

  def started
    @competition = Competition.find(params[:id])
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, tables: true)
    if !@competition.started
      redirect_to @competition
    end
  end

  def matches
    @matches = Competition.find(params[:id]).team_seeds
    @results = Competition.find(params[:id]).results.accepted
    respond_to do |f|
      f.json { render :json => {teams: @matches, results: @results} }
    end
  end

  def is_participating?(c_id, user_id)
    teams = User.find(user_id).teams.pluck(:id)
    p_teams = Competition.find(c_id).teams.pluck(:id)

    for team in p_teams
      if teams.include?(team)
        return true
      end
    end
    return false
  end

  private
  def competition_params
    params.require(:competition).permit(:name, :description, :admin_name, :admin_mobile, :start_time, :team_size, team_ids: [])
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
