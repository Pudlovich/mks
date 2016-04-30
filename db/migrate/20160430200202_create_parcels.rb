class CreateParcels < ActiveRecord::Migration
  def change
    create_table :parcels do |t|
      t.string :name
      t.integer :width, null: false
      t.integer :height, null: false
      t.integer :depth, null: false
      t.decimal :weight, precision: 6, scale: 2, null: false
      t.decimal :price, precision: 6, scale: 2, null: false
      t.timestamps null: false
    end
  end
end
