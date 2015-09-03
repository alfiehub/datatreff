class UserTeamsController < ApplicationController
  def destroy
    user_team = UserTeam.find(params[:id])
    team_id = user_team.team_id
    team = Team.find(team_id)
    user_id = user_team.user_id
    if user_id != team.contact_person.id && (current_user.id == user_id || team.contact_person.id == current_user.id) && current_user.teams.pluck(:id).include?(team_id) && user_team.destroy
      flash[:success] = "Du fjernet et bruker fra laget."
    elsif user_id != team.contact_person.id && is_admin? && user_team.destroy
      flash[:success] = "Du fjernet et bruker fra laget."
    else
      flash[:danger] = "Du kan ikke fjerne denne brukeren."
    end
    redirect_to Team.find(team_id)
  end
end
