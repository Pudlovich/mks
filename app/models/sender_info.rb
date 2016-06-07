class SenderInfo < ActiveRecord::Base
  has_many :parcels

  validates :email, :contact_name, :zip_code, :address, :city, :phone_number, presence: true
  validates_format_of :email, with: Devise::email_regexp

  def basic_address
    "#{zip_code} #{city}"
  end
end
