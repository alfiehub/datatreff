class CreateScreenshots < ActiveRecord::Migration
  def change
    create_table :screenshots do |t|
      t.integer :result_id
      t.attachment :image
      t.timestamps null: false
    end
  end
end
