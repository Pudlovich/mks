class RecipientInfo < ActiveRecord::Base
  validates :email, :contact_name, :zip_code, :address, :city, :phone_number, presence: true
  validates_format_of :email,:with => Devise::email_regexp
end
