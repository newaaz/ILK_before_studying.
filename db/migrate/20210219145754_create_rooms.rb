class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :name      
      t.json :images
      t.integer :number, default: 1
      t.integer :size                 # площадь номера
      t.references :hotel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
