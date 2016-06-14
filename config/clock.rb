require 'clockwork'
require_relative 'boot'
require_relative 'environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(30.minutes,    'new.episodes',  tz: 'UTC') do
    source = 'http://joovideo.com'
    crawler = ::HomeCrawler.new(source)
    crawler.run
  end
  every(3.minutes, 'episode.media', tz: 'UTC') do
    ::Episode.favourite.unvisited.limit(1).each do |episode|
      crawler = ::EpisodeCrawler.new(episode.uri + '&HD=1', episode)
      crawler.run
    end
  end
end
