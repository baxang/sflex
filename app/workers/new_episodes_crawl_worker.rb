class NewEpisodesCrawlWorker
  include Sidekiq::Worker

  def perform
    source = 'http://joovideo.com'
    crawler = ::HomeCrawler.new(source)
    crawler.run
  end
end
