class ChangeParcelAcceptanceStatusNameToStatus < ActiveRecord::Migration
  def change
    rename_column :parcels, :acceptance_status, :status
  end
end
