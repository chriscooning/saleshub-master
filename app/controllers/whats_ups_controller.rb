class WhatsUpsController < MessagingController
  def new
    authorize!(:access, Action.new(:whats_ups, :create))
  end

  def create
    authorize!(:access, Action.new(:whats_ups, :create))

    @message = service.create(message_params)
    @message.message_type = message_type
    @message.is_published = true

    if @message.save
      broadcast "/channels/#{configatron.faye.channels.whats_ups}", {
        html: render_to_string(partial: "whats_ups/item",
        locals: { msg: @message.decorate, is_even: false })
      }
      respond_to do |format|
        format.html do
          redirect_to whats_ups_path
        end
        format.json do
          render status: 201,
            json: {
              html: render_to_string(partial: 'form', formats: :html)
            }
        end
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json do
          render status: 422,
                 json: {
                   html: render_to_string(partial: 'form', formats: :html, locals: { message: @message })
                 }
        end
      end
    end
  end

  def index
    authorize!(:access, Action.new(:whats_ups, :read))

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
    authorize!(:access, Action.new(:whats_ups, :read))

    @message = decorate(base_scope.find(params[:id]))
  end

  private

  def service
    ::Services::Messages.new(as: current_user)
  end

  def message_type
    Message::Types::WHATS_UP
  end

  def message_params
    params.require(:message).permit(allowed_attributes[:message])
  end

  def allowed_attributes
    {
      message: [:title, :body]
    }
  end
end
