class AddInfoReferencesToParcels < ActiveRecord::Migration
  def change
    add_column :parcels, :sender_info_id, :integer, index: true, null: false
    add_foreign_key :parcels, :sender_infos
    add_column :parcels, :recipient_info_id, :integer, index: true, null: false
    add_foreign_key :parcels, :recipient_infos
  end
end
