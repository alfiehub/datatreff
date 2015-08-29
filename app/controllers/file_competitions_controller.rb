class FileCompetitionsController < ApplicationController
  def new
    @competition = FileCompetition.new
  end

  def show
    @competition = FileCompetition.find(params[:id])
  end

  def create

  end

  def update
  end
end
