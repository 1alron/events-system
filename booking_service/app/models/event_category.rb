class EventCategory < ApplicationRecord
  belongs_to :event
  belongs_to :category
  has_many :reservations, dependent: :destroy
  has_many :tickets, dependent: :destroy

  validates :event_id, presence: true
  validates :category_id, presence: true
  validates :base_price, presence: true, numericality: { greater_than: 0 }

  scope :for_category, ->(category_name) { joins(:category).where(categories: { name: category_name }) }
end
