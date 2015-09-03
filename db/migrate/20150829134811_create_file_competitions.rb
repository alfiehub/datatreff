class CreateFileCompetitions < ActiveRecord::Migration
  def change
    create_table :file_competitions do |t|
      t.string :name
      t.text :description
      t.string :admin_name
      t.datetime :deadline
      t.timestamps null: false
    end
  end
end
