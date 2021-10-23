class Pair < ApplicationRecord
  belongs_to :user
  belongs_to :other, class_name: 'User'
  belongs_to :group
end
