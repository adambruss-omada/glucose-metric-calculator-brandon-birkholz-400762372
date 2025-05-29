class GlucoseLevel < ApplicationRecord
  # Represents a single glucose level measurement
  #
  # Attributes:
  # - value: The numeric value of the glucose level
  # - tested_at: The date and time of the measurement
  # - tz_offset: The timezone offset of the measurement
  # - member: The member who recorded the measurement
  #
  # Associations:
  # - belongs_to :member

  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :tested_at, presence: true
  validates :tz_offset, presence: true
  validates :member, presence: true

  belongs_to :member
end
