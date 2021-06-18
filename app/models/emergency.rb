class Emergency < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :fire_severity, :police_severity, :medical_severity, presence: true,
                                                                 numericality: { greater_than_or_equal_to: 0 }
end