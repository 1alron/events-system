class Ticket < ApplicationRecord
  belongs_to :event
  belongs_to :event_category

  validates :event_id, presence: true
  validates :user_id, presence: true
  validates :event_category_id, presence: true

  scope :blocked, -> { where(blocked: true) }
  scope :available, -> { where(blocked: false) }
end
