class AddDescToHotels < ActiveRecord::Migration[6.1]
  def change
    add_column :hotels, :food, :string          # Питание
    add_column :hotels, :parking, :string       # парковка
    add_column :hotels, :territory, :string     # на территории
    add_column :hotels, :addition, :string      # дополнительно
    add_column :hotels, :vk, :string            # ВК
    add_column :hotels, :instagram, :string     # Инста
    add_column :hotels, :transfer, :string      # Трансфер
    add_column :hotels, :service, :string      # Услуги

    add_column :hotels, :all_year, :boolean, default: false      # Работает круглогодично
    add_column :hotels, :floors, :smallint      # Количество этажей

    add_column :hotels, :desc_json, :json       # Описание услуг и удобств в виде JSON 
  end
end
