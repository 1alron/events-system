class ReplaceAgeWithBirthDateInUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :birth_date, :date
    remove_column :users, :age, :integer
  end
end
