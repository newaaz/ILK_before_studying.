class CreateCategoryCounters < ActiveRecord::Migration[6.1]
  def change
    create_table :category_counters do |t|
      t.references :town, null: false, foreign_key: true
      t.string :cat_type                                # тип категории (hotel, active, point)
      t.integer :cat_id
      t.integer :cat_count, limit: 2, default: 1    # количество экземпляров категории 
      t.string :cat_name                            # название категории
    end
  end
end
