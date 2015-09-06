class User < ActiveRecord::Base
  EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  has_secure_password

  has_many :user_teams
  has_many :teams, through: :user_teams
  has_many :competitions, through: :teams
  has_many :pages
  has_many :results
  has_many :file_results

  validates :username, :name, :email, presence: true, uniqueness: true, length: { in: 1..26 }
  validates :mobile, presence: true, uniqueness: true, length: { is: 8 }
  validates_format_of :email, with: EMAIL_REGEX
  validates :password, presence: true, on: :create
end
