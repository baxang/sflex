RSpec.describe HomeCrawler do
  let(:source) { 'http://joovideo.com' }

  subject(:crawler) { described_class.new(source) }

  vcr_options = { cassette_name: 'HomeCrawler/joovideo-home' }

  before do
    crawler.run
  end

  it 'grabs', vcr: vcr_options do
    expect(crawler.data).to be_a(Array)
  end

  it 'first links', vcr: vcr_options do
    expect(crawler.data[0]).to eq ["또 오해영", "http://joovideo.com/ViewMedia.aspx?Num=1618137892738301965"]
  end
end
