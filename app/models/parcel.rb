class Parcel < ActiveRecord::Base
  belongs_to :sender, class_name: 'User'

  validates :width, :height, :depth, :weight, :price, presence: true
end
