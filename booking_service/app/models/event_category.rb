class EventCategory < ApplicationRecord
  belongs_to :event
  belongs_to :category
  has_many :reservations, dependent: :destroy
  has_many :tickets, dependent: :destroy

  validates :event_id, presence: true
  validates :category_id, presence: true
  validates :base_price, presence: true, numericality: { greater_than: 0 }

  scope :for_category, ->(category_name) { joins(:category).where(categories: { name: category_name }) }

  def sold_and_reserved
    tickets.count + reservations.active.count
  end

  def available_tickets
    category.tickets_count - sold_and_reserved
  end

  def current_price
    return nil if event.date < Time.current
    return base_price if sold_and_reserved.zero?
    batches_sold = (sold_and_reserved * 10 / available_tickets).floor
    (base_price * (1.1 ** batches_sold)).round(2)
  end

  def price_range
    prices = {}
    batch_size = (available_tickets / 10.0).ceil

    10.times do |batch|
      start_ticket = batch * batch_size + 1
      end_ticket = [ (batch + 1) * batch_size, available_tickets ].min
      count = end_ticket - start_ticket + 1

      next if count <= 0

      price = base_price
      batch.times { price *= 1.1 }
      price = price.round(2)

      prices[price] = count
    end

    prices
  end

  private

  def sold_tickets_not_exceed_available
    if sold_tickets > available_tickets
      errors.add(:sold_tickets, "не может превышать количество доступных билетов")
    end
  end
end
