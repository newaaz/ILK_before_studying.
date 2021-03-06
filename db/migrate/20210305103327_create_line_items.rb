class CreateLineItems < ActiveRecord::Migration[6.1]
  def change
    create_table :line_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.string :resource_name
      t.integer :resource_id      
    end
  end
end
