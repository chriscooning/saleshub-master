class CommentsController < ApplicationController
  def create
    @message = find_message

    @comment = Comment.new(comment_params) do |comment|
      comment.message = @message
      comment.parent = find_parent
      comment.created_by = current_user
    end

    if @comment.save
      if @message.token.present?
        broadcast "/channels/#{@message.token}/comments", {
          html: render_to_string(partial: 'comments/comment',
                                 locals: { comment: @comment.decorate })
        }
      end

      head :created
    else
      head :bad_request
    end
  end

  private

  def find_message
    if params[:briefing_id].present?
      Message.where(message_type: Message::Types::BRIEFING).published.find(params[:briefing_id])
    elsif params[:whats_up_id].present?
      Message.where(message_type: Message::Types::WHATS_UP).published.find(params[:whats_up_id])
    else
      raise ActionController::ParameterMissing
    end
  end

  def find_parent
    if params[:parent_id].present?
      Comment.where(message_id: find_message.id, id: params[:parent_id]).first
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
