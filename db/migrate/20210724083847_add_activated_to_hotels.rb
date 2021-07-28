class AddActivatedToHotels < ActiveRecord::Migration[6.1]
  def change
    add_column :hotels, :activated, :boolean, default: false
    add_column :hotels, :enabled, :boolean, default: true
    add_column :hotels, :deleted, :boolean, default: false
  end
end
