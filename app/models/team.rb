class Team < ActiveRecord::Base
  has_many :user_teams
  has_many :users, through: :user_teams

  has_many :competition_teams
  has_many :competitions, through: :competition_teams

  validates :name, presence: true
  validates_uniqueness_of :name

  def contact_person
    self.users.order('user_teams.created_at ASC').first
  end

  def name=(new_name)
    TeamSeed.find_by_team_name(self[:name]).update_attribute(:team_name, new_name)
    self[:name] = new_name
  end

  def self.tryfind(id)
    if id.nil?
      nil
    else
      find(id)
    end
  end
end
