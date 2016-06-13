module Crawler
  include ActiveSupport::Concern

  attr_reader :source, :record

  def initialize(source, record = nil)
    @source = source
    @record = record
  end

  private

  def agent
    @agent ||= Mechanize.new
    @agent.tap do |agent|
      agent.user_agent_alias = 'Windows IE 11'
    end
  end

  def page
    (@page ||= agent.get(source)).tap do |page|
      page.encoding = 'UTF-8'
    end
  end

  def links
    page.links
  end

end
