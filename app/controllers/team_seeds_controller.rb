class TeamSeedsController < ApplicationController
  before_filter :authorize_admin

  def index
    @competition = Competition.find(params[:competition_id])
    @team_seeds = @competition.team_seeds.order(:seed)
  end

  def new
    @competition = Competition.find(params[:competition_id])
    @team_seed = @competition.team_seeds.new()
  end

  def create
    @competition = Competition.find(params[:competition_id])
    @team_seed = TeamSeed.new(team_seed_params)
    if @team_seed.save
      @team_seed.update_attribute(:competition_id, @competition.id)
      flash[:success] = "Du opprettet et nytt TeamSeed!"
      redirect_to competition_team_seeds_path(@competition)
    else
      flash.now[:danger] = "Du noober, slutt."
      render :new
    end
  end

  def edit
    @competition = Competition.find(params[:competition_id])
    @team_seed = TeamSeed.find(params[:id])
  end

  def update
    @competition = Competition.find(params[:competition_id])
    @team_seed = TeamSeed.find(params[:id])
    if @team_seed.update_attributes(team_seed_params)
      flash[:success] = "Du oppdatert team_seeden!"
      redirect_to competition_team_seeds_path(@competition)
    else
      flash.now[:danger] = "Ikke vær noob, da."
      render :edit
    end
  end

  def destroy
    @competition = Competition.find(params[:competition_id])
    @team_seed = TeamSeed.find(params[:id])
    if !@competition.started && @team_seed.destroy
      flash[:success] = "Du slettet TeamSeeden!"
    else
      flash[:danger] = "Noe gikk galt, du kunne ikke slette TeamSeeden. Kanskje konkurransen har startet?"
    end
    redirect_to competition_team_seeds_path(@competition)
  end

  private
  def team_seed_params
    params.require(:team_seed).permit(:team_name, :competition_id, :seed)
  end
end
