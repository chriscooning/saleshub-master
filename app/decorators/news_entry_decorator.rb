class NewsEntryDecorator < AppDecorator
  include ActionView::Helpers::TextHelper

  SHORT_BODY_LENGTH = 200
  delegate_all

  def short_body
    @_short_body ||= truncate(model.body, length: SHORT_BODY_LENGTH)
  end

  def date
    @_date ||= (publication_date.strftime("%b #{publication_date.day.ordinalize}, %Y"))
  end

  def external_link?
    model.external? && model.link.present?
  end

  def link
    @_link ||= model.link.html_safe
  end

  private

  def publication_date
    @_publication_date ||= model.pub_date || model.created_at
  end
end
