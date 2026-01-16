class Reservation < ApplicationRecord
  belongs_to :event_category

  validates :event_category_id, presence: true

  scope :active, -> { where(active: true) }
  scope :expired, -> { where("valid_to < ?", Time.current) }

  delegate :event, to: :event_category
end
