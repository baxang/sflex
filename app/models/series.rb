class Series < ApplicationRecord
  has_many :episodes, inverse_of: :series
end
