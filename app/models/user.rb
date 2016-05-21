class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :parcels, foreign_key: 'sender_id'

  enum role: {
    client: 0,
    employee: 1,
    admin: 2
  }
end
