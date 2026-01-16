class Ticket < ApplicationRecord
  belongs_to :event_category

  validates :user_id, presence: true
  validates :event_category_id, presence: true

  scope :blocked, -> { where(blocked: true) }
  scope :available, -> { where(blocked: false) }

  delegate :event, to: :event_category
end
