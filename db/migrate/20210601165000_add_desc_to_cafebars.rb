class AddDescToCafebars < ActiveRecord::Migration[6.1]
  def change
    add_column :cafebars, :desc_json, :json
  end
end
