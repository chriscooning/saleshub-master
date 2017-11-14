class MessageDecorator < AppDecorator
  include ActionView::Helpers::DateHelper
  delegate_all

  decorates_association :comments

  def created_at
    model.created_at && model.created_at.xmlschema
  end

  def body
    model.body.html_safe
  end

  def created_at_formatted
    model.created_at.strftime('%m/%d/%Y, %I:%M%p').downcase
  end

  def author
    is_anonymous? ? 'Anonymous' : author_name
  end

  def status
    is_published? ? 'Published' : 'Draft'
  end

  def type_name
    case message_type
      when Message::Types::BASIC then
        :messages
      when Message::Types::BRIEFING then
        :briefings
      when Message::Types::WHATS_UP then
        :whats_ups
      else
        :messages
    end
  end
end
