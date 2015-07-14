class AddTeamSizeToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :team_size, :integer
  end
end
