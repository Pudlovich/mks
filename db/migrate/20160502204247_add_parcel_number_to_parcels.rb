class AddParcelNumberToParcels < ActiveRecord::Migration
  def change
    add_column :parcels, :parcel_number, :string, null: false, limit: 20
  end
end
