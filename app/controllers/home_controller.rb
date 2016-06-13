class HomeController < ApplicationController
  def welcome
    episodes = Episode
                 .select('episodes.*, MAX(media.created_at) AS latest_media')
                 .joins(:media)
                 .includes(:series)
                 .group('episodes.id')
                 .order('latest_media DESC')
    render locals: { episodes: episodes }
  end
end
