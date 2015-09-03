class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :name
      t.string :admin_name
      t.string :admin_mobile
      t.boolean :started, default: false
      t.timestamp :start_time

      t.timestamps null: false
    end
  end
end
