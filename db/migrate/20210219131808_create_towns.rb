class CreateTowns < ActiveRecord::Migration[6.1]
  def change
    create_table :towns do |t|
      t.string :name
      t.string :parent_name
      t.string :avatar
      t.integer :number, default: 1, limit: 1 
    end
  end
end
