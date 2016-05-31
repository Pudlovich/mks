class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :parcels, foreign_key: 'sender_id'
  has_many :operations

  enum role: {
    client: 0,
    employee: 1,
    admin: 2
  }

  validates :role, presence: true

  scope :newest_first, -> { order(created_at: :desc) }
end
