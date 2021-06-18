class CreateServicesTowns < ActiveRecord::Migration[6.1]
  def change
    create_table :services_towns, id: false do |t|

      t.references :service, null: false, foreign_key: true
      t.references :town, null: false, foreign_key: true

    end
  end
end
