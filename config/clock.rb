require 'clockwork'
require_relative 'boot'
require_relative 'environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.hour,    'new.episodes',  tz: 'UTC', at: '**:17') do
    source = 'http://joovideo.com'
    crawler = ::HomeCrawler.new(source)
    crawler.run
  end
  every(5.minutes, 'episode.media', tz: 'UTC') do
    ::Episode.favourite.unvisited.limit(1).each do |episode|
      crawler = ::EpisodeCrawler.new(episode.uri, episode)
      crawler.run
    end
  end
end
