class CreateActivesTowns < ActiveRecord::Migration[6.1]
  def change
    create_table :actives_towns, id: false do |t|
      t.references :active, null: false, foreign_key: true
      t.references :town, null: false, foreign_key: true    
    end
  end
end
