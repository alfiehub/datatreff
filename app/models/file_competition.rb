class FileCompetition < ActiveRecord::Base
  has_many :file_results
  has_many :users, through: :file_results

  validates :name, :description, :admin_name, :admin_email, :deadline, presence: true
end
