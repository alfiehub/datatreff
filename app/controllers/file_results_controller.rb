class FileResultsController < ApplicationController
  def index
    @results = FileResult.all
  end

  def new
    @result = FileResult.new
    @competition = FileCompetition.find(params[:file_competition_id])
  end

  def create
    @result = FileResult.new(file_result_params)
    @result.update_attribute(:user_id, current_user.id)
    @result.update_attribute(:file_competition_id, params[:file_competition_id])
    if @result.save
      flash[:success] = "Ditt resultat har blitt sendt inn!"
      redirect_to @result
    else
      render 'new'
    end
  end

  def show
    @result = FileResult.find(params[:id])
  end

  def edit
  end

  def update
  end

  private
  def file_result_params
    params.require(:file_result).permit(:name, :comment, :contribution, :file_competition_id)
  end
end
