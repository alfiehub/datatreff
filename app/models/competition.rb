class Competition < ActiveRecord::Base
  has_many :competition_teams
  has_many :teams, through: :competition_teams
  has_many :matchups
  has_many :users, through: :teams
  has_many :results
  has_many :team_seeds

  validates :name, :description, :admin_name, :admin_mobile, :start_time, :team_size, presence: true

end
