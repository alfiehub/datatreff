class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :competition
  has_many :screenshots, dependent: :destroy

  scope :accepted, -> { where(validated: true) }

  validates :team1_id, :team2_id, :team1_score, :team2_score, presence: true
end
