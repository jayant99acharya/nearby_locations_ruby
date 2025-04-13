class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :address
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string :category

      t.timestamps
    end
  end
end
