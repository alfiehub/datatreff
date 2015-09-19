class FileResultsController < ApplicationController
  before_filter :authorize_admin, only: [:destroy]
  before_filter :authorize, only: [:index, :new, :create, :edit, :update]
  before_filter :event_started

  def index
    @competition = FileCompetition.find(params[:file_competition_id])
    if is_admin?
      @results = @competition.file_results.order(score: :desc)
    else
      @results = current_user.file_results.where(file_competition_id: @competition.id)
    end
  end

  def new
    @result = FileResult.new
    @competition = FileCompetition.find(params[:file_competition_id])
  end

  def create
    @competition = FileCompetition.find(params[:file_competition_id])

    if Time.now > @competition.deadline
      flash[:danger] = "Beklager, fristen har gått ut!"
      redirect_to @competition
    else
      @result = FileResult.new(file_result_params)
      if @result.save
        @result.update_attribute(:user_id, current_user.id)
        @result.update_attribute(:file_competition_id, params[:file_competition_id])
        flash[:success] = "Ditt bidrag har blitt sendt inn!"
        redirect_to file_competition_file_results_path(@competition)
      else
        flash.now[:danger] = 'Noe gikk galt.'
        render 'new', object: @competition
      end
    end
  end

  def show
    @result = FileResult.find(params[:id])
  end

  def edit
    @result = FileResult.find(params[:id])
    @competition = FileCompetition.find(params[:file_competition_id])
  end

  def update
    @result = FileResult.find(params[:id])
    @competition = @result.file_competition
    if is_admin? && @result.update_attributes(admin_file_result_params)
      flash[:success] = "Du oppdaterte resultatet."
      redirect_to file_competition_file_results_path(@competition)
    elsif @result.update_attributes(file_result_params)
      flash[:success] = "Du oppdaterte resultatet."
      redirect_to file_competition_file_results_path(@competition)
    else
      flash.now[:danger] = "Resultatet ble ikke oppdatert, da noe gikk galt."
      render 'edit'
    end
  end

  private
  def file_result_params
    params.require(:file_result).permit(:name, :comment, :contribution, :file_competition_id)
  end

  private
  def admin_file_result_params
    params.require(:file_result).permit(:name, :comment, :contribution, :file_competition_id, :score, :admin_comment)
  end
end
