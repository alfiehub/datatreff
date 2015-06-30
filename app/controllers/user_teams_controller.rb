class UserTeamsController < ApplicationController
  def destroy
    user_team = UserTeam.find(params[:id])
    team_id = user_team.team_id
    user_id = user_team.user_id
    if user_id != current_user.id && current_user.teams.pluck(:id).include?(team_id) && user_team.destroy
      flash[:success] = "LOL"
    else
      flash[:failure] = ":("
    end
    redirect_to Team.find(team_id)
  end
end
