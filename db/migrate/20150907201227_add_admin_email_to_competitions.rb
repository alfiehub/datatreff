class AddAdminEmailToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :admin_email, :string
    add_column :file_competitions, :admin_email, :string
  end
end
