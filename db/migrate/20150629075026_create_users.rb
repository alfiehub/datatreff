class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :email
      t.string :mobile
      t.string :password_digest
      t.boolean :admin, default: false

      t.timestamps null: false
    end
  end
end
