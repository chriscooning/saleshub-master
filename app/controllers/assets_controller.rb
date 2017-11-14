class AssetsController < ApplicationController
  newrelic_ignore_enduser only: [:manifest]

  respond_to :json, only: [:index]
  respond_to :smil, only: [:manifest]

  PAGE = configatron.dmc.assets.default_page
  PER  = configatron.dmc.assets.default_per

  def index
    gallery_id = params[:gallery_id]
    folder_id  = params[:folder_id]
    page = (Integer(params[:page]) rescue nil) || PAGE
    per  = PER
    assets = service.assets(
      gallery_id: gallery_id,
      folder_id:  folder_id,
      page: page,
      per:  per
    )
    respond_with AssetSerializer.serialize(assets)
  end

  def manifest
    render text: service.asset_manifest(
      gallery_id: params[:gallery_id],
      folder_id:  params[:folder_id],
      asset_id:   params[:id]
    )
  end

  private

  def service
    @_service ||= ::Services::Dmc.new(as: current_user)
  end
end