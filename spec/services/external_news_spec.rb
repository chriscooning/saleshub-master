require "spec_helper"

describe Services::ExternalNews do
  FEED_DIR = "#{Rails.root}/spec/fixtures/feed_files"
  RSS_FEED_URIS = %Q{
    file:///#{FEED_DIR}/fruit-vegetable-news/index.rss
    file:///#{FEED_DIR}/fruit-vegetable-events/live-from-pma-2013-photos/index.rss
  }.split
  EXTRA_RSS_FEED_URI = "file:///#{FEED_DIR}/fruit-vegetable-news/produce-industry-leaders/Rising_Stars/index.rss"

  it "scans for news" do
    expect(NewsEntry.count).to eq 0
    service = Services::ExternalNews.new
    service.scan(RSS_FEED_URIS)

    news = NewsEntry.all.to_a
    expect(news.size).to eq 11
    expect(news.map { |it| it.news_type}.uniq).to eq(
      [NewsEntry::Types::EXTERNAL]
    )
    first_news = news.first
    expect(first_news.title).to eq "Miss Florida takes National Watermelon Association Queen crown"
    expect(first_news.link).to eq "http://www.thepacker.com/fruit-vegetable-news/National-Watermelon-Association-convention-kicks-off-246572801.html"
    expect(first_news.link_hashcode).to eq 3277757000
    expect(first_news.body).to eq %q{
      SAVANNAH, Ga. – A convention celebrating milestones – the 100th anniversary of the National Watermelon Association and 50 years of the watermelon queen program – culminated in Brandi Harrison’s crowning as 2014 NWA Queen Feb. 22.
    }.strip
    expect(first_news.pub_date).to eq "Mon, 24 Feb 2014 14:44:54 UTC +00:00".to_time

    # News entries count should still the same.
    # There should be no dups.
    service.scan(RSS_FEED_URIS)
    expect(NewsEntry.count).to eq 11

    # But new URI should be parsed
    service.scan([EXTRA_RSS_FEED_URI])
    expect(NewsEntry.count).to eq 18
  end
end