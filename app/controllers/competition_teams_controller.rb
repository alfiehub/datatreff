class CompetitionTeamsController < ApplicationController
  def destroy
    comp_team = CompetitionTeam.find(params[:id])
    comp_id = comp_team.competition_id
    if comp_team.destroy
      redirect_to competition_path(comp_id)
    end
  end

  def update
    comp_team = CompetitionTeam.find(params[:id])
    comp_team.update_attribute(:checked_in, true)
    comp_team.save
    flash[:success] = "Laget ditt har blitt sjekket inn! Følg med ved konkurransestart."
    redirect_to competition_path(comp_team.competition_id)
  end
end
