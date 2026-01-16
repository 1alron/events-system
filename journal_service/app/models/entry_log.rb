class EntryLog < ApplicationRecord
    enum action: { entry: 'entry', exit: 'exit' }

    scope :successful, -> { where(successful: true) }
end
