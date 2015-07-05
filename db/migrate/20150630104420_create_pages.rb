class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.boolean :main_menu, default: false
      t.boolean :front_page, default: false

      t.timestamps null: false
    end
  end
end
