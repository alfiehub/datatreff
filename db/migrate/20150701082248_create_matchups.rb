class CreateMatchups < ActiveRecord::Migration
  def change
    create_table :matchups do |t|
      t.integer :team1_id
      t.integer :team2_id
      t.timestamp :start_time
      t.integer :round_number
      t.integer :match_number
      t.boolean :lower_bracket
      t.integer :competition_id
      t.integer :result_id

      t.timestamps null: false
    end
  end
end
