require 'thor/rails'

class Crawl < Thor
  include Thor::Rails

  package_name 'Crawl'

  desc 'home', 'Scrape home'
  def home
    source = 'http://joovideo.com'
    crawler = ::HomeCrawler.new(source)
    crawler.episode_links.each do |link|
      ::Episode.find_or_initialize_by(uri: link.resolved_uri.to_s).tap do |episode|
        if episode.new_record?
          episode.series = Series.find_or_create_by(title: link.text)
        end
        episode.title = link.text
        puts "#{link.text} saved." if (episode.new_record? || episode.changed?) && episode.save!
      end
    end
  end

  desc 'view', 'View'
  def view
    medium_link_pattern = Regexp.new("^(H-)?델리모션([^이])".force_encoding('UTF-8'), Regexp::FIXEDENCODING)
    agent = ::Mechanize.new.tap do |ag|
      ag.user_agent_alias = 'Windows IE 11'
    end
    ::Episode.unvisited.limit(1).each do |episode|
      puts "Crawling #{episode.uri}."
      page = agent.get(episode.uri + '&HD=1')
      page.encoding = 'UTF-8'

      page.at_css('#ctl00_ContentPlaceHolder1_ViewMedia1_lblEpisodeNum').text.match(/^(.*) - ([^(]+) \(([^)]+)\)/).tap do |match|
        if match
          series_title = $1
          program_title = $2
          medium_title = $3
          episode.series.tap do |series|
            series.title = series_title
            series.save if series.changed?
          end
          ::Series.find_or_initialize_by(title: series_title).tap do |series|
            series.save
            puts "Updating title: #{$1}/#{$2}"
            episode.series = series
            episode.title  = program_title
            episode.save
          end
        end
      end

      form = page.form('aspnetForm')

      links = page.links.select { |link| link.text =~ medium_link_pattern }
      links.each do |link|
        title = link.text
        link.href.match(/__doPostBack\('([^']+)'/)
        value = $1
        puts "#{title} - EVENTTARGET:#{value}"
        form.__EVENTTARGET = value
        media_page = form.submit
        media_page.encoding = 'UTF-8'
        medium_node = media_page.iframe_with(name: 'frameFlash')
        ::Medium.find_or_initialize_by(episode: episode, uri: medium_node.src).tap do |m|
          m.title = title
          # m.tag = medium_node.node.to_html
          m.save!
        end
        episode.touch(:visited_at)
        sleep(2)
      end
    end
    # source = 'file:///' + File.realdirpath('data/view1.html')
    # source = 'http://joovideo.com/ViewMedia.aspx?Num=1628552453994119178&HD=1'
    # agent = ::Mechanize.new
    # agent.user_agent_alias = 'Windows IE 11'
    # page = agent.get(source)
    # page.encoding = 'UTF-8'
    # form = page.form('aspnetForm')
    #
    # parts = page.links.select { |l| l.text =~ medium_link_pattern }
    # values = parts.map { |p| p.href.match(/__doPostBack\('([^']+)'/)[1] }
    # form.__EVENTTARGET = values.first
    # sleep 1
    # byebug
    # form.submit
  end

end
