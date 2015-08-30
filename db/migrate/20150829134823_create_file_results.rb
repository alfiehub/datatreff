class CreateFileResults < ActiveRecord::Migration
  def change
    create_table :file_results do |t|
      t.integer :user_id
      t.string :name
      t.text :comment
      t.integer :score
      t.text :admin_comment
      t.integer :file_competition_id
    end
  end
end
