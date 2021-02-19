class CreateHotelCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :hotel_categories do |t|
      t.string :name
      t.integer :number, default: 1, limit: 1
    end
  end
end
