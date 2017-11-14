class PagesController < ApplicationController
  MESSAGES_COUNT = configatron.pages.home.messages_count
  INTERNAL_NEWS_COUNT = configatron.pages.home.news.internal.count
  EXTERNAL_NEWS_COUNT = configatron.pages.home.news.external.count

  before_filter :fetch_news_entries, only: [:create_survey]

  def home
    set_action(:dashboard)
    @survey = ::Services::Surveys.new(as: current_user).build
    @states = ::Services::Geo.us_states_inverted
    @messages = fetch_messages(Message::Types::BASIC, :messages)
    @briefings = fetch_messages(Message::Types::BRIEFING, :briefings)
    # @whats_ups = fetch_messages(Message::Types::WHATS_UP, :whats_ups)
    fetch_news_entries
  end

  def resources
    set_action(:resources)
    service = ::Services::Dmc.new(as: current_user)
    @galleries = service.galleries
  end

  def create_survey
    authorize!(:access, Action.new(:surveys, :create))
    @survey = ::Services::Surveys.new(as: current_user).create(current_user, survey_params)
    if @survey.valid?
      flash[:notice] = "Survey was successfully created"
      redirect_to action: :home
    else
      flash[:error] = "Please check your input"
      render template: 'pages/home'
    end
  end

  private

  def fetch_messages(type = 0, action_scope = :messages)
    if can?(:access, Action.new(action_scope, :read))
      messages = Message.includes(:gallery => :images).where(message_type: type).published.featured.by_position

      unless messages.present?
        messages  = Message.includes(:gallery => :images).where(message_type: type).published.by_position.limit(MESSAGES_COUNT)
      end

      MessageDecorator.decorate_collection(messages)
    end
  end

  def fetch_news_entries
    if can?(:access, Action.new(:news, :read))
      internal_news_entries  = NewsEntry.internal.limit(INTERNAL_NEWS_COUNT)
      @internal_news_entries = NewsEntryDecorator.decorate_collection(internal_news_entries)
      external_news_entries  = NewsEntry.external.limit(EXTERNAL_NEWS_COUNT)
      @external_news_entries = NewsEntryDecorator.decorate_collection(external_news_entries)
    end
  end

  def survey_params
    params.require(:survey).permit(
      :customer_name, :phone, :phone_extension, :address, :zipcode, :city,
      :state, :summary, :last_interaction_rating
    )
  end
end
