class Idea < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :idea, presence: true
end
