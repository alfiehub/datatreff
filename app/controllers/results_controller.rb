class ResultsController < ApplicationController
  before_filter :authorize_admin, only: [:destroy]
  before_filter :authorize, only: [:index, :new, :edit, :create, :update]
  before_filter :event_started

  def index
    @competition = Competition.find(params[:competition_id])
    if is_admin?
      @results = @competition.results.order(:validated, :lower_bracket, :round, :match)
    else
      @results = current_user.results.where(competition_id: @competition.id).order(:validated, :lower_bracket, :round, :match)
    end
  end

  def new
    @competition = Competition.find(params[:competition_id])
    @result = Result.new
    if !(@competition.users.pluck(:id).include?(current_user.id) || is_admin?)
      flash[:warning] = "Du har ikke tillatelse til dette."
      redirect_to @competition
    end
  end

  def create
    @result = is_admin? ? Result.new(admin_result_params) : Result.new(result_params)
    @competition = Competition.find(params[:competition_id])
    if is_admin? && @result.save
      @result.update_attribute(:competition_id, @competition.id)
      @result.update_attribute(:user_id, current_user.id)
      flash[:success] = "Du har meldt inn et resultat, administrator vil godkjenne det så fort som mulig"
      redirect_to competition_results_path(@competition)
    elsif !params[:result][:screenshots].nil? && params[:result][:screenshots].length > 0 && @result.save
      @result.update_attribute(:competition_id, @competition.id)
      @result.update_attribute(:user_id, current_user.id)
      params[:result][:screenshots].each do |s|
        @result.screenshots.create(image: s)
      end
      flash[:success] = "Du har meldt inn et resultat, administrator vil godkjenne det så fort som mulig"
      redirect_to competition_results_path(@competition)
    elsif params[:result][:screenshots].nil?
      flash.now[:danger] = 'Noe gikk galt, har du husket screenshots?'
      render "new"
    else
      flash.now[:danger] = 'Noe gikk galt.'
      render "new"
    end
  end

  def edit
    @result = Result.find(params[:id])
    @competition = Competition.find(params[:competition_id])
    if !(is_admin? || @result.user.id == current_user.id)
      flash[:warning] = "Du har ikke tillatelse til dette."
      redirect_to @competition
    elsif @result.validated && !is_admin?
      flash[:warning] = "Du kan ikke endre resultatet når det allerede er godkjent.."
      redirect_to @competition
    end
  end

  def update
    @result = Result.find(params[:id])
    @competition = Competition.find(params[:result][:competition_id])
    if is_admin? && @result.update_attributes(admin_result_params)
      if !params[:result][:screenshots].nil?
        @result.screenshots.destroy_all
        params[:result][:screenshots].each do |s|
          @result.screenshots.create(image: s)
        end
      end
      flash[:success] = "Du oppdaterte resultatet."
      redirect_to @competition
    elsif !@result.validated && @result.user.id == current_user.id && @result.update_attributes(result_params) 
      @result.update_attribute(:competition_id, @competition.id)
      if !params[:result][:screenshots].nil?
        @result.screenshots.destroy_all
        params[:result][:screenshots].each do |s|
          @result.screenshots.create(image: s)
        end
      end
      flash[:success] = "Du oppdaterte resultatet."
      redirect_to edit_competition_result_path(@competition, @result)
    elsif @result.validated
      flash[:danger] = "Resultatet ble IKKE oppdatert, da det er allerede godkjent."
      redirect_to @competition
    else
      flash.now[:danger] = "Noe gikk galt."
      render :edit
    end
  end

  def destroy
    @result = Result.find(params[:id])
    if (@result.user.id == current_user.id || is_admin?) && !@result.validated && @result.destroy
      flash[:success] = "Du slettet et resultat"
    else
      flash[:warning] = "Noe gikk galt, resultatet er kanskje godkjent?"
    end
    puts params
    redirect_to competition_results_path(Competition.find(params[:competition_id]))
  end

  private
  def result_params
    params.require(:result).permit(:team1_id, :team1_score, :team2_id, :team2_score, :competition_id, :screenshots)
  end

  private
  def admin_result_params 
    params.require(:result).permit(:team1_id, :team1_score, :team2_id, :team2_score, :competition_id, :round, :match, :lower_bracket, :validated, :image)
  end
end
