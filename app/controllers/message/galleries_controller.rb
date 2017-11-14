class Message::GalleriesController < ApplicationController
  respond_to :json, only: [:destroy]

  def destroy
    authorize!(:access, Action.or(:message, [:edit, :create]))
    gallery = find_gallery

    if gallery.destroy
      head :ok
    else
      head :bad_request
    end
  end

  private

  def find_gallery
    Message::Gallery.
      where('created_by_id = ? OR message_id IS NOT NULL', current_user.id).
      find(params[:id])
  end
end
