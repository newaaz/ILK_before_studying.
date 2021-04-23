class AddDescToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :avatar, :string         # главное фото
    add_column :rooms, :description, :json      # Описание подробное
  end
end
