class AddUserRefToParcels < ActiveRecord::Migration
  def change
    add_column :parcels, :sender_id, :integer, index: true
    add_foreign_key :parcels, :users, column: :sender_id
  end
end
