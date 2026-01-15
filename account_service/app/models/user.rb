class User < ApplicationRecord
  has_secure_password

  validates :document_type, :document_number, presence: true
  validates :document_number, uniqueness: { scope: :document_type }
end
