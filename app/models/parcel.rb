class Parcel < ActiveRecord::Base
  belongs_to :sender, class_name: 'User'
  belongs_to :sender_info
  belongs_to :recipient_info

  has_many :operations

  enum acceptance_status: {
    pending: 0,
    accepted: 1,
    rejected: 2
  }

  delegate :city, to: :recipient_info, prefix: :recipient
  delegate :zip_code, to: :recipient_info, prefix: :recipient
  delegate :city, to: :sender_info, prefix: :sender
  delegate :zip_code, to: :sender_info, prefix: :sender

  accepts_nested_attributes_for :sender_info
  accepts_nested_attributes_for :recipient_info

  attr_localized :price, :weight

  validates :width, :height, :depth, :weight, :price, :parcel_number, :sender_info, :recipient_info, :acceptance_status, presence: true
  validates :weight, :price, numericality: { greater_than: 0 }
  validates :height, :depth, :width, numericality: { only_integer: true, greater_than: 0 }
  validates :parcel_number, uniqueness: true

  before_validation :set_price, :generate_parcel_number, on: :create

  scope :newest_first, -> { order(created_at: :desc) }

  def accept!(author=nil)
    unless self.accepted?
      self.update(acceptance_status: 'accepted')
      Operation.create(parcel: self, kind: 'order_accepted', user: author)
    end
  end

  def reject!(author=nil)
    unless self.rejected?
      self.update(acceptance_status: 'rejected')
      Operation.create(parcel: self, kind: 'order_rejected', user: author)
    end
  end

  private

  def set_price
    # dummy pricing function, to be substituted by actual business logic
    self.price = 10
  end

  def generate_parcel_number
    # returns a nine-digit parcel number - eight random digits and check digit generated using Luhn algorithm
    self.parcel_number = loop do
      number = SecureRandom.random_number(90000000)+10000000
      parcel_number = number.to_s + Luhn.control_digit(number).to_s
      break parcel_number unless Parcel.exists?(parcel_number: parcel_number)
    end
  end
end
