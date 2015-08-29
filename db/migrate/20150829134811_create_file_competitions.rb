class CreateFileCompetitions < ActiveRecord::Migration
  def change
    create_table :file_competitions do |t|
      t.string :name
      t.string :admin_name
      t.string :admin_email
      t.datetime :deadline
      t.timestamps null: false
    end
  end
end
