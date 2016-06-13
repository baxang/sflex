require 'thor/rails'

class Crawl < Thor
  include Thor::Rails

  package_name 'Crawl'

  desc 'home', 'Crawls Homepage and save new episodes.'
  def home
    source = 'http://joovideo.com'
    crawler = ::HomeCrawler.new(source)
    crawler.run
  end

  desc 'episode', 'Crawls a new episode.'
  def view
    ::Episode.unvisited.limit(1).each do |episode|
      crawler = ::EpisodeCrawler.new(episode.uri, episode)
      crawler.run
    end
  end

end
