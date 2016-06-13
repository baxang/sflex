class Medium < ApplicationRecord
  belongs_to :episode, inverse_of: :media

  def uri
    uri = URI(read_attribute(:uri))
    uri.scheme = nil
    uri.to_s
  end
end
