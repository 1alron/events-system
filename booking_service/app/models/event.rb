class Event < ApplicationRecord
  has_many :reservations
  has_many :tickets

  validates :name, presence: true
  validates :date, presence: true
end
