class AddAvatarToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :avatar, :string
    add_column :users, :phone, :string
  end
end
