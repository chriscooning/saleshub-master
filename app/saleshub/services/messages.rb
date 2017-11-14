class Services::Messages < ::Services::Base
  include ::TruncateHtmlHelper
  include ActionView::Helpers::SanitizeHelper

  def create(attributes)
    attrs = prepare_attributes(attributes)
    Message.new(attrs).tap do |msg|
      msg.created_by = accessor if accessor
      msg.author_name  = UserDecorator.decorate(accessor).name if accessor
      if msg.whats_up?
        msg.is_published = true
        msg.is_featured = false
        msg.is_anonymous = false
      end
      msg.save
    end
  end

  def update(message, attributes)
    message.assign_attributes(prepare_attributes(attributes))
    if message.whats_up?
      message.is_published = true
      message.is_featured = false
      message.is_anonymous = false
    end
    message.save
    message
  end

  def reorder(ids, from, to)
    return false unless ids.is_a?(Array)
    return false unless ids.all?{ |id| id.is_a?(String) || id.is_a?(Integer) }

    positions = Range.new(from, to).to_a.reverse
    messages = Message.find(ids).uniq

    return false unless messages.count.eql?(positions.count)

    Message.transaction do
      ids.each_with_index do |id, index|
        Message.update(id, position: positions[index])
      end
    end

    true
  end

  private

  def prepare_attributes(attributes)
    attributes.dup.tap do |attrs|
      if attrs[:title].present?
        attrs[:title] = attrs[:title].truncate(Message::Limits::TITLE)
      end
      if attrs[:body].present?
        attrs[:body] = sanitize(attrs[:body], tags: %w( p b i u a br ol ul li img blockquote ), attributes: %w( src href ) )
        attrs[:body] = truncate_html(attrs[:body], length: Message::Limits::BODY)
      end
    end
  end
end
