class CreateBrands < ActiveRecord::Migration[7.1]
  def change
    create_table :brands do |t|
      t.string :name
      t.boolean :state, default: true, null: false
      t.jsonb :customize_fields

      t.timestamps
    end
  end
end
