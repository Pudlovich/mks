class Parcel < ActiveRecord::Base
  belongs_to :sender, class_name: 'User'

  attr_localized :price, :weight

  validates :width, :height, :depth, :weight, :price, :parcel_number, presence: true
  validates :weight, :price, numericality: { greater_than: 0 }
  validates :height, :depth, :width, :parcel_number, numericality: { only_integer: true, greater_than: 0 }

  before_validation :set_price, :generate_parcel_number, on: :create

  private

  def set_price
    # dummy pricing function, to be substituted by actual business logic
    self.price = 10
  end

  def generate_parcel_number
    # returns a ten-digit parcel number - nine random digits and check digit generated using Luhn algorithm
    self.parcel_number = loop do
      number = SecureRandom.random_number(90000000)+10000000
      parcel_number = 10 * number + Luhn.control_digit(number)
      break parcel_number unless Parcel.exists?(parcel_number: parcel_number)
    end
  end
end
