class CreateServices < ActiveRecord::Migration[6.1]
  def change
    create_table :services do |t|
      t.string :name      # Название
      t.string :avatar    # Главное фото
      t.json :images      # Остальные изображения
      t.string :address   # Адрес

      t.json :desc_json   # описание json

      t.integer :rating, limit: 2, default: 10      # Рейтинг
      t.integer :random_id, limit: 2, default: 1    # Случайный ID
      t.boolean :enabled, default: true             # Показывать/Не показывать
      t.boolean :activated, default: false          # Активировано/ Не Активировано
      t.boolean :deleted, default: false            # Удалено / Не удалено

      t.decimal :longitude, precision: 6, scale: 4
      t.decimal :latitude, precision: 6, scale: 4  

      t.references :user, null: false, foreign_key: true
      t.references :service_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
