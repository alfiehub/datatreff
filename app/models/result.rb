class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :competition

  scope :accepted, -> { where(validated: true) }

  validates :team1_id, :team2_id, :team1_score, :team2_score, presence: true
end
