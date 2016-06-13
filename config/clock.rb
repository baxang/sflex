require 'clockwork'
require_relative 'boot'
require_relative 'environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.hour,    'new.episodes',  tz: 'UTC', at: '**:17') { NewEpisodesCrawlWorker.perform_async }
  every(5.minutes, 'episode.media', tz: 'UTC') { FavouriteEpisodeCrawlWorker.perform_async }
end
