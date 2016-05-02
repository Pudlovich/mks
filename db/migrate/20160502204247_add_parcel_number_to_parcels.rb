class AddParcelNumberToParcels < ActiveRecord::Migration
  def change
    add_column :parcels, :parcel_number, :integer, null: false
  end
end
