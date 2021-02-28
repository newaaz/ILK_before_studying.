class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :guest_name
      t.string :guest_email
      t.string :guest_phone
      t.date :check_in
      t.date :check_out
      t.integer :adults, limit:1
      t.integer :kids, limit:1
      t.integer :room_id
      t.text :wishes
      t.boolean :reservation_confirmed, default: false
      t.boolean :payment_successful, default: false
      t.string :owner_comment
      t.integer :total_amount
      
      t.integer :user_id
      t.references :hotel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
