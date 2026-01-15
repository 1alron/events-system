class Category < ApplicationRecord
  has_many :event_categories, dependent: :destroy
  has_many :events, through: :event_categories
  has_many :reservations, through: :event_categories
  has_many :tickets, through: :event_categories

  validates :name, presence: true, uniqueness: true
end
