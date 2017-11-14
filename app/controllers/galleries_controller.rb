class GalleriesController < ApplicationController
  def show
    gallery_id = params[:id]
    @gallery = service.find_gallery(gallery_id)
    @folders = service.folders(gallery_id: gallery_id)
    if @folders.present?
      first_folder = @folders.first
      redirect_to gallery_folder_path(
        gallery_id: gallery_id, id: first_folder.id
      )
    else
      render 'empty'
    end
  end

  private

  def service
    @_service ||= ::Services::Dmc.new(as: current_user)
  end
end