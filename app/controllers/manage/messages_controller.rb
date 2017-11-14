module Manage
  class MessagesController < BaseController
    respond_to :json, only: [:update]

    def new
      if cannot?(:access, Action.new(:messages, :create)) &&
        cannot?(:access, Action.new(:briefings, :create)) &&
        cannot?(:access, Action.new(:whats_ups, :create))

        raise CanCan::AccessDenied
      end

      @message = Message.new
    end

    def create
      authorize_by_type_and_action!(message_params[:message_type].to_i, :create)

      @message = service.create(message_params)

      if @message.valid?
        if (gallery = find_gallery).present?
          gallery.message = @message
          gallery.save
        end

        if @message.is_published?
          type_name = @message.decorate.type_name

          broadcast "/channels/#{configatron.faye.channels.send(type_name)}", {
            html: render_to_string(partial: "#{type_name}/item",
                         locals: { msg: @message.decorate, is_even: false })
          }
        end

        flash[:notice] = 'Message was created successfully'
        redirect_to edit_manage_message_path(@message)
      else
        @message.gallery = find_gallery
        flash[:error] = 'Please check your input'
        render action: :new
      end
    end

    def index
      if can?(:access, Action.or(:messages, [:create, :update, :delete]))
        redirect_to action: :customer_messaging
      elsif can?(:access, Action.or(:briefings, [:create, :update, :delete]))
        redirect_to action: :briefings
      elsif can?(:access, Action.or(:whats_ups, [:create, :update, :delete]))
        redirect_to action: :whats_ups
      else
        raise CanCan::AccessDenied
      end
    end

    def customer_messaging
      set_action(:messages)

      authorize!(:access, Action.or(:messages, [:update, :delete]))

      scope = typed_scope(Message::Types::BASIC)

      @total_count = scope.count
      @messages = decorate_collection(paginate(scope))
      @messages_type = :messages

      render :index
    end

    def briefings
      set_action(:messages)

      authorize!(:access, Action.or(:briefings, [:update, :delete]))

      scope = typed_scope(Message::Types::BRIEFING)

      @total_count = scope.count
      @messages = decorate_collection(paginate(scope))
      @messages_type = :briefings

      render :index
    end

    def whats_ups
      set_action(:messages)

      authorize!(:access, Action.or(:whats_ups, [:update, :delete]))

      scope = typed_scope(Message::Types::WHATS_UP)

      @total_count = scope.count
      @messages = decorate_collection(paginate(scope))
      @messages_type = :whats_ups

      render :index
    end

    def edit
      @message = find_message

      authorize_by_type_and_action!(@message.message_type, :update)
    end

    def update
      @message = find_message

      authorize_by_type_and_action!(@message.message_type, :update)

      @message = service.update(@message, message_params)

      type_name = @message.decorate.type_name

      if @message.is_published?
        broadcast "/channels/#{configatron.faye.channels.send(type_name)}", {
          html: render_to_string(partial: "#{type_name}/item",
                       locals: { msg: @message.decorate, is_even: false })
        }
      elsif @message.previous_changes.include?(:is_published)
        broadcast "/channels/#{configatron.faye.channels.send(type_name)}", {
          json: { id: @message.id, is_unpublished: true }
        }
      end

      respond_with do |format|
        format.html do
          if @message.valid?
            flash[:notice] = 'Message was updated successfully'
            redirect_to edit_manage_message_path(@message)
          else
            flash[:error] = 'Please check your input'
            render action: :edit
          end
        end

        format.json do
          render json: { html: render_to_string({
                                                  partial: 'row',
                                                  formats: :html,
                                                  locals: {
                                                    message: @message.decorate
                                                  }
                                                })
          }
        end
      end
    end

    def destroy
      @message = find_message

      authorize_by_type_and_action!(@message.message_type, :delete)

      if @message.destroy
        flash[:notice] = 'Message was deleted'
        type_name = @message.decorate.type_name
        broadcast "/channels/#{configatron.faye.channels.send(type_name)}", {
          json: { id: @message.id, is_deleted: true }
        }
      else
        flash[:error] = "Message could not be deleted"
      end

      redirect_to action: :index
    end

    def reorder
      authorize!(:access, Action.or(:messages, [:update]))

      if service.reorder(params[:ids], params[:position][:from], params[:position][:to])
        head code: 200
      else
        head code: 422
      end
    end

    private

    def paginate(scope)
      scope.paginate(pagination_scope)
    end

    def decorate(object)
      MessageDecorator.decorate(object)
    end

    def decorate_collection(collection)
      MessageDecorator.decorate_collection(collection)
    end

    def base_scope
      Message.by_position.accessible_by(current_user, rule_operation_code)
    end

    def typed_scope(type)
      base_scope.where(message_type: type)
    end

    def service
      ::Services::Messages.new(as: current_user)
    end

    def message_params
      params.require(:message).permit(allowed_attributes[:message])
    end

    def allowed_attributes
      {
        message: [:message_type,
                  :title,
                  :body,
                  :is_anonymous,
                  :is_published,
                  :is_featured,
                  :bootsy_image_gallery_id]
      }
    end

    def find_message
      base_scope.find(params[:id])
    end

    def find_gallery
      Message::Gallery.
        where(created_by_id: current_user.id).
        where(message_id: nil).
        where(id: params[:gallery_id]).first
    end

    def rule_operation_code
      case params[:action]
        when 'new', 'create' then 'create'
        when 'index', 'show' then 'read'
        when 'customer_messaging' then 'update'
        when 'briefings' then 'update'
        when 'whats_ups' then 'update'
        when 'edit', 'update' then 'update'
        when 'destroy' then 'delete'
      end
    end
  end
end
