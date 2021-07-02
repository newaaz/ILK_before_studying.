class CreateActives < ActiveRecord::Migration[6.1]
  def change
    create_table :actives do |t|
      t.string :name      # Название
      t.string :avatar    # Главное фото
      t.json :images      # Остальные изображения

      t.integer :price, limit: 3

      t.json :desc_json   # Описание json

      t.string :seo_keywords        # ключевые слова для СЕО
      t.string :seo_description     # description слова для СЕО

      t.integer :rating, limit: 2, default: 10      # Рейтинг
      t.integer :random_id, limit: 2, default: 1    # Случайный ID
      t.integer :promouted, limit: 2, default: 0    # Рекламное продвижение  

      t.boolean :enabled, default: true             # Показывать/Не показывать
      t.boolean :activated, default: false          # Активировано/ Не Активировано
      t.boolean :deleted, default: false            # Удалено / Не удалено

      t.decimal :longitude, precision: 6, scale: 4
      t.decimal :latitude, precision: 6, scale: 4  

      t.references :user, null: false, foreign_key: true
      t.references :active_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
