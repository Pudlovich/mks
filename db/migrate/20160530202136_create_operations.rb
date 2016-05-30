class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.string :place
      t.string :additional_info
      t.integer :kind, null: false
      t.timestamps null: false
    end
    add_reference :operations, :user, index: true, foreign_key: true, null: false
    add_reference :operations, :parcel, index: true, foreign_key: true, null: false
  end
end
