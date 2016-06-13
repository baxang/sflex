class Series < ApplicationRecord
  has_many :episodes, inverse_of: :series

  scope :favourite, -> { where(favourite: true) }
end
