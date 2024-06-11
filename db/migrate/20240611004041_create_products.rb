class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.references :brand, null: false, foreign_key: true
      t.decimal :price
      t.string :currency
      t.boolean :state, default: true, null: false
      t.jsonb :customize_fields

      t.timestamps
    end
  end
end
