class CreateClientCards < ActiveRecord::Migration[7.1]
  def change
    create_table :client_cards do |t|
      t.references :client, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.decimal :price
      t.string :currency
      t.string :active_number
      t.string :pin_code
      t.integer :active_method
      t.integer :state

      t.timestamps
    end
  end
end
