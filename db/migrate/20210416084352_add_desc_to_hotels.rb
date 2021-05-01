class AddDescToHotels < ActiveRecord::Migration[6.1]
  def change
    add_column :hotels, :all_year, :boolean, default: false      # Работает круглогодично
    add_column :hotels, :desc_json, :json       # Описание услуг и удобств в виде JSON 
  end
end
