class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :email, null: false, index: { unique: true }
      t.string :serect_key, index: { unique: true }
      t.integer :payout_rate
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
