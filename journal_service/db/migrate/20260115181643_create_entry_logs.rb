class CreateEntryLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :entry_logs do |t|
      t.integer :ticket_id
      t.string :full_name
      t.date :event_date
      t.string :ticket_category
      t.string :turnstile_category
      t.string :action
      t.boolean :successful
      t.string :message
      t.datetime :occurred_at

      t.timestamps
    end
  end
end
