class Ticket < ApplicationRecord
  belongs_to :event

  enum :category, { vip: 1, fanzone: 0 }

  validates :event_id, presence: true
  validates :user_id, presence: true
  validates :category, presence: true

  scope :blocked, -> { where(blocked: true) }
  scope :available, -> { where(blocked: false) }

  def vip?
    category == 'vip' || category == 0
  end

  def fanzone?
    category == 'fanzone' || category == 1
  end
end
