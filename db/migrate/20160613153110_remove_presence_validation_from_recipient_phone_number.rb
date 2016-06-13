class RemovePresenceValidationFromRecipientPhoneNumber < ActiveRecord::Migration
  def change
    change_column_null :recipient_infos, :phone_number, true
  end
end
