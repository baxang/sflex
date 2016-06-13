class Medium < ApplicationRecord
  belongs_to :episode, inverse_of: :media
end
