class CreateTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :tickets do |t|
      t.references :event, null: false, foreign_key: true
      t.bigint :user_id, null: false
      t.boolean :blocked, null: false, default: false
      t.references :event_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
