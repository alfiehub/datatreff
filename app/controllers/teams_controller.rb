class TeamsController < ApplicationController
  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to root_path, notice: "Laget ditt har blitt opprettet."
    else
      render "new"
    end
  end

  private
  def team_params
    params.require(:team).permit(:name, user_ids: [])
  end
end
