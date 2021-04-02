class CreateTagcafebars < ActiveRecord::Migration[6.1]
  def change
    create_table :tagcafebars do |t|
      t.string :name
      t.string :icon
    end
  end
end
