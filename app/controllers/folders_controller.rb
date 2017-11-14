class FoldersController < ApplicationController
  def show
    set_action(:resources)
    gallery_id  = params[:gallery_id]
    s_folder_id = Integer(params[:id]) rescue nil

    @gallery  = service.find_gallery(gallery_id)
    @folders = service.folders(gallery_id: gallery_id)
    # @folder  = @folders.detect { |f| f.id == s_folder_id }
    # if @folder.blank?
    #   raise ::Errors::Dmc::NotFound.create(
    #     entity_name: 'Folder',
    #     id: s_folder_id
    #   )
    # end
  end

  private

  def service
    @_service ||= ::Services::Dmc.new(as: current_user)
  end
end