class AddDescToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :avatar, :string         # главное фото
    add_column :rooms, :furniture, :string      # мебель
    add_column :rooms, :bathroom, :string       # санузел/душ
    add_column :rooms, :addition, :string       # дополнительно
    add_column :rooms, :in_room, :string        # в номере

    add_column :rooms, :guests, :smallint       # кол-во гостей
    add_column :rooms, :floor, :smallint        # этаж
    add_column :rooms, :rooms, :smallint        # количество комнат
  end
end
