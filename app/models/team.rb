class Team < ActiveRecord::Base
  has_many :user_teams
  has_many :users, through: :user_teams

  has_many :competition_teams
  has_many :competitions, through: :competition_teams

  def self.tryfind(id)
    if id.nil?
      nil
    else
      find(id)
    end
  end
end
