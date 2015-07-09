class User < ActiveRecord::Base
  has_secure_password

  has_many :user_teams
  has_many :teams, through: :user_teams
  has_many :competitions, through: :teams
  has_many :pages
  has_many :results

  validates_uniqueness_of :username, :email, :mobile
  validates :username, :name, :mobile, :email, presence: true
  validates :password, presence: true, on: :create
end
