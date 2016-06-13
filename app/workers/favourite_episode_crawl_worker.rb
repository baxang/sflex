class FavouriteEpisodeCrawlWorker
  include Sidekiq::Worker

  def perform
    ::Episode.favourite.unvisited.limit(1).each do |episode|
      crawler = ::EpisodeCrawler.new(episode.uri, episode)
      crawler.run
    end
  end

end
