class CreatePointCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :point_categories do |t|
      t.string :name
      t.string :avatar
      t.integer :number, default: 1, limit: 1
    end
  end
end
