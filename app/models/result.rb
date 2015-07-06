class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :competition

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  scope :accepted, -> { where(validated: true) }

  validates :team1_id, :team2_id, :team1_score, :team2_score, presence: true
end
