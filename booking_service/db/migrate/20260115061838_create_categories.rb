class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.integer :tickets_count, null: false, default: 100

      t.timestamps
    end

    add_index :categories, :name, unique: true
  end
end
