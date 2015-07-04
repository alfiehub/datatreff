class CreateTeamSeeds < ActiveRecord::Migration
  def change
    create_table :team_seeds do |t|
      t.integer :team_id
      t.integer :competition_id
      t.integer :index

      t.timestamps null: false
    end
  end
end
