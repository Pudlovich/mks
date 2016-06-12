class SenderInfo < ActiveRecord::Base
  has_many :parcels

  validates :email, :contact_name, :zip_code, :address, :city, :phone_number, presence: true
  validates_format_of :email, with: Devise::email_regexp

  def name
    if company_name.present?
      company_name
    else
      contact_name
    end
  end

  def basic_address
    "#{zip_code} #{city}"
  end
end
