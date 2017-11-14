class MessagesController < MessagingController
    def index
    authorize!(:access, Action.new(:messages, :read))

    set_action(:messages)
    @search = search_scope
    @result = @search.result(distinct: true)
    @total_count = @result.count
    @messages = decorate_collection(paginate(@result))

    if request.xhr?
      render '_items', locals: { messages: @messages }, layout: false
    end
  end

  private

  def message_type
    Message::Types::BASIC
  end
end
