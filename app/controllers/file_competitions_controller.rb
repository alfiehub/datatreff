class FileCompetitionsController < ApplicationController
  before_filter :authorize_admin, only: [:new, :create, :edit, :update]

  def new
    @competition = FileCompetition.new
  end

  def show
    @competition = FileCompetition.find(params[:id])
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, tables: true)
  end

  def create
    @competition = FileCompetition.new(file_competition_params)
    if @competition.save
      flash[:success] = "Du laget en ny konkurranse"
      redirect_to @competition
    else
      render "new"
    end
  end

  def edit
    @competition = FileCompetition.find(params[:id])
  end

  def update
    @competition = FileCompetition.find(params[:id])
    if @competition.update_attributes(file_competition_params)
      flash[:success] = "Du endret konkurransen."
      redirect_to @competition
    else
      render 'edit'
    end
  end

  private
  def file_competition_params
    params.require(:file_competition).permit(:name, :description, :admin_name, :admin_email, :deadline)
  end
end
