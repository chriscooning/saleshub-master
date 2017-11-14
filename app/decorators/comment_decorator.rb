class CommentDecorator < AppDecorator
  include ActionView::Helpers::DateHelper
  delegate_all

  decorates_association :children
  decorates_association :created_by

  def created_at_formatted
    model.created_at.strftime('%m/%d/%Y, %I:%M%p').downcase
  end

  def content
    h.simple_format(model.content.sanitize).html_safe
  end

  def level
    if parent.blank?
      1
    elsif parent.parent.blank?
      2
    else
      3
    end
  end
end
