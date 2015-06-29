class CreateCompetitionTeams < ActiveRecord::Migration
  def change
    create_table :competition_teams do |t|
      t.integer :competition_id
      t.integer :team_id

      t.timestamps null: false
    end
    add_index :competition_teams, :competition_id
    add_index :competition_teams, :team_id
  end
end
