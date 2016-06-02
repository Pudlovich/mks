class Parcel < ActiveRecord::Base
  belongs_to :sender, class_name: 'User'
  belongs_to :sender_info
  belongs_to :recipient_info

  has_many :operations

  enum acceptance_status: {
    awaiting: 0,
    accepted: 1,
    rejected: 2
  }

  delegate :city, to: :recipient_info, prefix: :recipient

  accepts_nested_attributes_for :sender_info
  accepts_nested_attributes_for :recipient_info

  attr_localized :price, :weight

  validates :width, :height, :depth, :weight, :price, :parcel_number, :sender_info, :recipient_info, :acceptance_status, presence: true
  validates :weight, :price, numericality: { greater_than: 0 }
  validates :height, :depth, :width, numericality: { only_integer: true, greater_than: 0 }
  validates :parcel_number, uniqueness: true

  scope :newest_first, -> { order(created_at: :desc) }

  before_validation :set_price, :generate_parcel_number, on: :create
  after_create :create_order_created_operation

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

  def create_order_created_operation
    operation = Operation.new(parcel: self, kind: 'order_created')
    operation.user = self.sender if self.sender
    operation.save
  end
end
