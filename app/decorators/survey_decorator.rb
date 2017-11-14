class SurveyDecorator < AppDecorator
  include ActionView::Helpers::NumberHelper
  delegate_all

  def formatted_id
    number_with_delimiter(model.id)
  end
end