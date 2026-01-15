class CreateTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :tickets do |t|
      t.references :event, null: false, foreign_key: true
      t.bigint :user_id, null: false
      t.boolean :blocked, null: false, default: false
      t.integer :category, null: false, default: 0

      t.timestamps
    end
  end
end
