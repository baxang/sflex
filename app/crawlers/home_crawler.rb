class HomeCrawler

  include Crawler

  def run
    episode_links.each do |link|
      ::Episode.find_or_initialize_by(uri: link.resolved_uri.to_s).tap do |episode|
        if episode.new_record?
          episode.series = Series.find_or_create_by(title: link.text)
          episode.title = link.text
          episode.save!
          puts "#{link.text} saved."
        end
      end
    end
    true
  end

  private

  def episode_links(name = nil)
    links.select { |l| l.href =~ /^ViewMedia\.aspx\?Num=[0-9]+$/ }.reject { |l| l.text == name }
  end


end
