class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true
  validates :role, presence: true,
    inclusion: { in: %w(member admin moderator restricted) }

  def admin?
    role == "admin"
  end

end

