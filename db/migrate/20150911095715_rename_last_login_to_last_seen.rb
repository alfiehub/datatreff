class RenameLastLoginToLastSeen < ActiveRecord::Migration
  def change
    rename_column :users, :last_login, :last_seen
  end
end
