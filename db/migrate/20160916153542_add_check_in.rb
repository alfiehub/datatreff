class AddCheckIn < ActiveRecord::Migration
  def change
    add_column :competition_teams, :checked_in, :boolean, default: false
  end
end
