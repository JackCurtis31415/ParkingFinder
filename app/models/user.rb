class User < ActiveRecord::Base
  has_many :parking_searches
  has_many :saved_places
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
    validates :username, presence: true
end
