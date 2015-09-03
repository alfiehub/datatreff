class Team < ActiveRecord::Base
  has_many :user_teams
  has_many :users, through: :user_teams

  has_many :competition_teams
  has_many :competitions, through: :competition_teams

  validates :name, presence: true, length: { maximum: 11 }, uniqueness: true

  def contact_person
    self.users.order('user_teams.created_at ASC').first
  end

  def ordered_users
    self.users.order('user_teams.created_at ASC')
  end

  def name=(new_name)
    while !TeamSeed.find_by_team_name(self[:name]).nil?
      TeamSeed.find_by_team_name(self[:name]).update_attribute(:team_name, new_name)
    end
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
