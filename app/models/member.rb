class Member < ApplicationRecord
  has_many :glucose_levels

  validates :name, presence: true
end
