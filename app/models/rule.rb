class Rule < ApplicationRecord
  belongs_to :group

  normalizes :text, with: ->(text) { text.squish }

  validates :text, presence: true, length: {maximum: 200}
end
