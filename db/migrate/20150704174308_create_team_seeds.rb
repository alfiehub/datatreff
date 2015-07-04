class CreateTeamSeeds < ActiveRecord::Migration
  def change
    create_table :team_seeds do |t|
      t.string :team_name
      t.integer :competition_id
      t.integer :seed

      t.timestamps null: false
    end
  end
end
