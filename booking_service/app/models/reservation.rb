class Reservation < ApplicationRecord
  belongs_to :event
  belongs_to :event_category

  validates :event_id, presence: true
  validates :event_category_id, presence: true
  validates :user_id, presence: true

  scope :active, -> { where(active: true) }
  scope :expired, -> { where("valid_to < ?", Time.current) }

  def vip?
    category == "vip" || category == 0
  end

  def fanzone?
    category == "fanzone" || category == 1
  end
end
