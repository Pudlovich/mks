class Parcel < ActiveRecord::Base
  belongs_to :sender, class_name: 'User'

  attr_localized :price, :weight

  validates :width, :height, :depth, :weight, :price, presence: true
  validates :weight, :price, numericality: { greater_than: 0 }
  validates :height, :depth, :width, numericality: { only_integer: true, greater_than: 0 }
end
