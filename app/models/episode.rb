class Episode < ApplicationRecord
  belongs_to :series, inverse_of: :episodes
  has_many :media, inverse_of: :episode, dependent: :destroy

  validates_presence_of :series, allow_nil: true

  scope :favourite, -> { joins(:series).where(series: { favourite: true }) }
  scope :unvisited, -> { where(visited_at: nil) }

  def full_title
    [series.try(:title), title].join(' ')
  end
end
