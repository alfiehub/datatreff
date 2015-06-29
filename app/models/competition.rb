class Competition < ActiveRecord::Base
  has_many :competition_teams
  has_many :teams, through: :competition_teams

  has_many :users, through: :teams
end
