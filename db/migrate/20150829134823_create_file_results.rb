class CreateFileResults < ActiveRecord::Migration
  def change
    create_table :file_results do |t|

      t.timestamps null: false
    end
  end
end
