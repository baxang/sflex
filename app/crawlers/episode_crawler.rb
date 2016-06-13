class EpisodeCrawler

  include Crawler

  MEDIUM_LINK_REGEX = Regexp.new("^(H-)?델리모션([^이])".force_encoding('UTF-8'), Regexp::FIXEDENCODING)
  EPISODE_TITLE_REGEX = /^(.*) - ([^(]+) \(([^)]+)\)/

  alias_method :episode, :record

  def run
    puts "Crawling #{source}."

    page.at_css('#ctl00_ContentPlaceHolder1_ViewMedia1_lblEpisodeNum').text.match(EPISODE_TITLE_REGEX).tap do |match|
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
          episode.title = program_title
          episode.save
        end
      end
    end

    form = page.form('aspnetForm')

    links = page.links.select { |link| link.text =~ MEDIUM_LINK_REGEX }
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
    true
  end

end
