class SurveysController < ApplicationController
  def index
    set_action(:surveys)
    authorize!(:access, Action.new(:surveys, :read))
    surveys = Survey.all.paginate(pagination_scope)
    @surveys = SurveyDecorator.decorate_collection(surveys)
  end

  private

  def service
    ::Services::Surveys.new(as: current_user)
  end
end