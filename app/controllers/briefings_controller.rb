class BriefingsController < MessagingController
  def index
    authorize!(:access, Action.new(:briefings, :read))

    set_action(:messages)
    @search = search_scope
    @result = @search.result(distinct: true)
    @total_count = @result.count
    @messages = decorate_collection(paginate(@result))

    if request.xhr?
      render '_items', locals: { messages: @messages }, layout: false
    end
  end

  def show
    authorize!(:access, Action.new(:briefings, :read))

    @message = decorate(base_scope.find(params[:id]))
  end

  private

  def message_type
    Message::Types::BRIEFING
  end
end
