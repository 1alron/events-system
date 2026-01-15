class Event < ApplicationRecord
  has_many :reservations
  has_many :tickets
  has_many :event_categories, dependent: :destroy
  has_many :categories, through: :event_categories

  validates :name, presence: true
  validates :date, presence: true

  def category_price(category_name)
    event_categories.joins(:category)
                    .find_by(categories: { name: category_name })
      &.base_price
  end

  def add_category(category, base_price)
    event_categories.create!(
      category: category,
      base_price: base_price
    )
    end
end
