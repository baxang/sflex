class HomeCrawler

  attr_reader :source, :page

  def initialize(source)
    @source = source
  end

  def page
    @page ||= agent.get(source)
  end

  def links
    page.links
  end

  def episode_links(name = nil)
    links.select { |l| l.href =~ /^ViewMedia\.aspx\?Num=[0-9]+$/ }.reject { |l| l.text == name }
  end

  def agent
    @agent ||= Mechanize.new
    @agent.tap do |agent|
      agent.user_agent_alias = 'Windows IE 11'
    end
  end

  def reset
    @page = nil
  end

end
