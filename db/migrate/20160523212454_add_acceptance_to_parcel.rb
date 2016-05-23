class AddAcceptanceToParcel < ActiveRecord::Migration
  def change
    add_column :parcels, :acceptance, :integer, null: false, default: 0
  end
end
