# encoding: UTF-8

class Services::NewsEntries < ::Services::Base
  # attributes [Hash] with keys :title, :body
  def create_internal(attributes)
    attrs = attributes.merge(
      news_type: NewsEntry::Types::INTERNAL,
      pub_date: Time.now,
      created_by: @accessor
    )
    create(attrs)
  end

  # attributes [Hash] with keys :title, :link, :body
  def create_external(attributes)
    link = attributes[:link]
    raise 'link is blank' if link.blank?
    link = link.truncate(NewsEntry::Limits::LINK)
    attributes[:link_hashcode] = link_hashcode(link)
    attributes[:link] = sanitize(link)
    attrs = attributes.merge(news_type: NewsEntry::Types::EXTERNAL)
    create(attrs)
  end

  def entry_exists?(link, guid = nil)
    if guid.present?
      NewsEntry.exists?(guid: guid) || NewsEntry.exists?(link_hashcode: link_hashcode(link))
    else
      NewsEntry.exists?(link_hashcode: link_hashcode(link))
    end
  end

  private

  def create(attributes)
    entry = NewsEntry.create(prepare_attributes(attributes))

    if entry.persisted?
      decorated = News::BaseDecorator.decorate(entry)
      serializer = News::BaseSerializer.new(decorated)
      Services::Broadcaster.broadcast(:news, json: serializer.serialize)
    end

    entry
  end

  def prepare_attributes(attributes)
    attributes.dup.tap do |attrs|
      if attrs[:title].present?
        title = attrs[:title].truncate(NewsEntry::Limits::TITLE)
        attrs[:title] = sanitize(title)
      end
      if attrs[:body].present?
        body = attrs[:body].truncate(NewsEntry::Limits::BODY)
        attrs[:body] = sanitize(body)
      end
    end
  end

  def link_hashcode(link)
    link && Zlib.crc32(link)
  end

  def sanitize(html)
    Sanitize.clean(html)
  end
end
