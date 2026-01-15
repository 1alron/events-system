class CreateReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :reservations do |t|
      t.references :event, null: false, foreign_key: true
      t.boolean :active, null: false, default: true
      t.bigint :user_id, null: false
      t.datetime :valid_to, null: false
      t.references :event_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
