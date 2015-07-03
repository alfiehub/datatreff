class ResultsController < ApplicationController
  before_filter :authorize_admin, only: [:index, :update, :edit, :destroy]

  def index
    @competition = Competition.find(params[:competition_id])
    @results = @competition.results
  end

  def new
    @competition = Competition.find(params[:competition_id])
    puts params
    @result = Result.new
  end

  def create
    @result = Result.new(result_params)
    if @result.save
      @result.update_attribute(:user_id, current_user.id)
      puts params
      flash[:success] = "Du har meldt inn et resultat, administrator vil godkjenne det så fort som mulig"
      redirect_to Competition.find(params[:result][:competition_id])
    else
      render "new"
    end
  end

  def edit
    @result = Result.find(params[:id])
    @competition = Competition.find(params[:competition_id])
  end

  def update
    @result = Result.find(params[:id])
    if @result.update_attributes(admin_result_params)
      flash[:success] = "Du oppdaterte resultatet."
      redirect_to Competition.find(params[:result][:competition_id])
    else
      render 'edit'
    end
  end

  def destroy
    @result = Result.find(params[:id])
    if @result.destroy
      flash[:success] = "Du slettet et resultat"
    else
      flash[:warning] = "Noe gikk galt."
    end
    puts params
    redirect_to competition_results_path(Competition.find(params[:competition_id]))
  end

  private
  def result_params 
    params.require(:result).permit(:team1_id, :team1_score, :team2_id, :team2_score, :competition_id)
  end

  private
  def admin_result_params 
    params.require(:result).permit(:team1_id, :team1_score, :team2_id, :team2_score, :competition_id, :round, :match, :lower_bracket, :validated)
  end
end
