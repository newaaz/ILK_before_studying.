class CreateCafebarsTagcafebars < ActiveRecord::Migration[6.1]
  def change
    create_table :cafebars_tagcafebars, id:false do |t|
      t.references :cafebar, null: false, foreign_key: true
      t.references :tagcafebar, null: false, foreign_key: true
    end
  end
end