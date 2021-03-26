class CreateCafebars < ActiveRecord::Migration[6.1]
  def change
    create_table :cafebars do |t|
      t.string :name      # Название
      t.string :avatar    # Главное фото
      t.json :images      # Остальные изображения
      t.string :address   # Адрес
      t.string :phone     # Телефон
      t.string :site      # Сайт
      t.string :email     # Почта
      t.string :instagram # Аккаунт в Instagram
      t.string :vk        # Аккаунт в VK

      t.integer :rating, limit: 2, default: 10      # Рейтинг
      t.integer :random_id, limit: 2, default: 1    # Случайный ID
      t.boolean :enabled, default: true             # Показывать/Не показывать
      t.boolean :activated, default: false          # Активировано/ Не Активировано
      t.boolean :deleted, default: false            # Удалено / Не удалено

      t.references :user, null: false, foreign_key: true
      t.references :town, null: false, foreign_key: true

      t.decimal :longitude, precision: 6, scale: 4
      t.decimal :latitude, precision: 6, scale: 4      

      t.timestamps
    end
  end
end
