class CreateEventCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :event_categories do |t|
      t.references :event, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.integer :base_price, null: false, default: 0

      t.timestamps
    end

    add_index :event_categories, [ :event_id, :category_id ], unique: true
  end
end
