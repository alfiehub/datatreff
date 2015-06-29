class CompetitionTeamsController < ApplicationController
  def destroy
    comp_team = CompetitionTeam.find(params[:id])
    comp_id = comp_team.competition_id
    if comp_team.destroy
      redirect_to competition_path(comp_id)
    end
  end
end
