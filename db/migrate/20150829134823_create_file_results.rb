class CreateFileResults < ActiveRecord::Migration
  def change
    create_table :file_results do |t|
      t.integer :user_id
      t.string :name
      t.integer :file_competition_id
      t.integer :position, default: nil
    end
  end
end
