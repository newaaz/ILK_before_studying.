class CreateHotels < ActiveRecord::Migration[6.1]
  def change
    create_table :hotels do |t|
      t.string  :name
      t.integer :price_from, limit: 3
      t.string  :address
      t.integer :distance_to_sea, limit: 1
      t.string  :avatar
      t.json    :images
      t.integer :rating, limit:1, default: 20         # рейтинг для порядка отображения
      t.integer :random_number, limit:1, default: 1   # номер для выборки случайного порядка
      t.string  :site
      t.string  :email

      t.references :user, null: false, foreign_key: true
      t.references :town, null: false, foreign_key: true
      t.references :hotel_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
