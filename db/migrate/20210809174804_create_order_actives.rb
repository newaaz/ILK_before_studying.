class CreateOrderActives < ActiveRecord::Migration[6.1]
  def change
    create_table :order_actives do |t|
      t.string :guest_name
      t.string :guest_email
      t.string :guest_phone
      t.date :wish_date
      t.integer :adults, limit:1
      t.text :wishes      
      t.integer :price
      t.boolean :payment_successful, default: false

      t.integer :user_id
      t.references :active, null: false, foreign_key: true      

      t.timestamps
    end
  end
end
