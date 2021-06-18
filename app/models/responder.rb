class Responder < ApplicationRecord
  self.inheritance_column = nil

  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true, inclusion: { in: 1..5 }
  validates :type, presence: true

  enum type: { Fire: 0, Police: 1, Medical: 2 }
end
