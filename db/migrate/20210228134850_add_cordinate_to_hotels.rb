class AddCordinateToHotels < ActiveRecord::Migration[6.1]
  def change
    add_column :hotels, :latitude, :decimal, precision: 6, scale: 4
    add_column :hotels, :longitude, :decimal,  precision: 6, scale: 4
  end
end
