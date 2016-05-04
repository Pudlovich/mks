class CreateSenderInfosAndRecipientInfos < ActiveRecord::Migration
  def change
    create_table :sender_infos do |t|
      t.string :email, null: false
      t.string :contact_name, null: false
      t.string :company_name
      t.string :zip_code, null: false
      t.string :address, null: false
      t.string :city, null: false
      t.string :phone_number, null: false
      t.boolean :residential, null: false
      t.string :other_info
      t.timestamps null: false
    end

    create_table :recipient_infos do |t|
      t.string :email, null: false
      t.string :contact_name, null: false
      t.string :company_name
      t.string :zip_code, null: false
      t.string :address, null: false
      t.string :city, null: false
      t.string :phone_number, null: false
      t.boolean :residential, null: false
      t.string :other_info
      t.timestamps null: false
    end
  end
end
