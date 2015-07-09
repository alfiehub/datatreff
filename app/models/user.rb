class User < ActiveRecord::Base
  EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  has_secure_password

  has_many :user_teams
  has_many :teams, through: :user_teams
  has_many :competitions, through: :teams
  has_many :pages
  has_many :results

  validates_uniqueness_of :username, :email, :mobile
  validates :username, :name, :mobile, :email, presence: true
  validates_format_of :email, with: EMAIL_REGEX
  validates :password, presence: true, on: :create
end
