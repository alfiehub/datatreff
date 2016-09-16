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
    if comp_team.team.users.include?(current_user) || is_admin?
      comp_team.update_attribute(:checked_in, true)
      comp_team.save
      flash[:success] = "Laget ditt har blitt sjekket inn! Følg med ved konkurransestart."
      redirect_to competition_path(comp_team.competition_id)
    else
      flash[:warning] = "Du har ikke lov til å gjøre dette."
      redirect_to competition_path(comp_team.competition_id)
    end
  end
end
