class CreateFileCompetitions < ActiveRecord::Migration
  def change
    create_table :file_competitions do |t|

      t.timestamps null: false
    end
  end
end
