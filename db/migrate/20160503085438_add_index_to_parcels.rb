class AddIndexToParcels < ActiveRecord::Migration
  def change
    add_index :parcels, :parcel_number, unique: true
  end
end
