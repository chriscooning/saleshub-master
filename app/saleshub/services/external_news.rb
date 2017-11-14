# encoding: UTF-8
require 'open-uri'

class Services::ExternalNews < ::Services::Base
  def scan(rss_feed_uris)
    rss_feed_uris.each { |uri| scan_feed(uri) }
  end

  private

  def scan_feed(uri)
    # thepacker.com feeds contain pubDate attribute
    ::Feedzirra::Feed.add_common_feed_element('pubDate')

    rss = ::Feedzirra::Feed.fetch_and_parse(uri)

    if rss.blank?
      raise 'rss is blank'
    end

    if rss.is_a?(Integer)
      raise "Feed fetch error. Http status: #{rss}"
    end

    (rss.entries || []).each do |item|
      create_news_entry(
        title:    item.title,
        link:     item.url,
        body:     item.summary,
        pub_date: item.published || rss.pubDate || Time.now,
        guid:     item.entry_id,
        image:    item.image
      )
    end
  end

  def create_news_entry(title: title, link: link, body: body, pub_date: pub_date, guid: guid, image: image)
    service = news_entries_service
    unless service.entry_exists?(link, guid)
      service.create_external(
        title:            title,
        link:             link,
        body:             body,
        pub_date:         pub_date,
        guid:             guid,
        remote_image_url: image_url(image.to_s)
      )
    end
  end

  def image_url(url)
    if url.include?('//i.huffpost.com/')
      url.sub(/thumbs\/s-/, 'thumbs/n-').sub(/-mini\./, '-large.')
    else
      url
    end
  end

  def news_entries_service
    @_news_entries_service ||= ::Services::NewsEntries.new
  end
end
