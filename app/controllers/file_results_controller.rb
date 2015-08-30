class FileResultsController < ApplicationController
  def index
    @competition = FileCompetition.find(params[:file_competition_id])
    if is_admin?
      @results = @competition.file_results.order(:score)
    else
      @results = current_user.file_results.where(file_competition_id: @competition.id)
    end
  end

  def new
    @result = FileResult.new
    @competition = FileCompetition.find(params[:file_competition_id])
  end

  def create
    @comp = FileCompetition.find(params[:file_competition_id])

    if Time.now > @comp.deadline
      flash[:danger] = "Beklager, fristen har gått ut!"
      redirect_to @comp
    else
      @result = FileResult.new(file_result_params)
      @result.update_attribute(:user_id, current_user.id)
      @result.update_attribute(:file_competition_id, params[:file_competition_id])
      if @result.save
        flash[:success] = "Ditt bidrag har blitt sendt inn!"
        redirect_to file_competition_file_results_path(@comp)
      else
        render 'new'
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
    if is_admin? && @result.update_attributes(admin_file_result_params)
      flash[:success] = "Du oppdaterte resultatet."
      redirect_to FileCompetition.find(params[:file_competition_id])
    elsif @result.update_attributes(file_result_params)
      flash[:success] = "Du oppdaterte resultatet."
      redirect_to FileCompetition.find(params[:file_competition_id])
    else
      flash[:danger] = "Resultatet ble ikke oppdatert, da noe gikk galt."
      redirect_to FileCompetition.find(params[:file_competition_id])
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
