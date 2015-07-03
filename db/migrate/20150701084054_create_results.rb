class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :team1_id
      t.integer :team2_id
      t.integer :team1_score
      t.integer :team2_score
      t.integer :competition_id
      t.integer :round
      t.integer :match
      t.boolean :lower_bracket
      t.integer :user_id
      t.boolean :validated, default: false

      t.timestamps null: false
    end
  end
end
