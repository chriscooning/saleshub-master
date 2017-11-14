class Services::Dmc < ::Services::Base
  PAGE = configatron.dmc.assets.default_page
  PER  = configatron.dmc.assets.default_per

  TIMEOUT_SEC      = configatron.dmc.timeout_sec
  OPEN_TIMEOUT_SEC = configatron.dmc.open_timeout_sec

  def initialize(as: accessor)
    super(as: as)
  end

  def galleries
    response = perform_get(galleries_url)
    structurize(response)
  end

  # FIXME: maybe implement separate API route for it?
  # Anyway, we could do some caching later so it would not be a performance issue though.
  def find_gallery(u_gallery_id)
    s_gallery_id = Integer(u_gallery_id) rescue nil
    galleries.detect { |it| it.id == s_gallery_id }.tap do |gallery|
      if gallery.blank?
        raise ::Errors::Dmc::NotFound.create(entity_name: 'Gallery', id: u_gallery_id)
      end
    end
  end

  def folders(gallery_id: gallery_id)
    response = perform_get(folders_url, gallery_id: gallery_id)
    structurize(response).tap { |folders| folders.each { |it| it.default_per_page = PER } }
  end

  def assets(gallery_id: gallery_id, folder_id: folder_id, page: page, per: per)
    response = perform_get(
      assets_url,
      gallery_id: gallery_id,
      folder_id: folder_id,
      page: page.present? ? page : PAGE,
      per:  per.present? ? per : PER
    )
    parsed_response = JSON.parse(response)
    items = parsed_response['collection'] || []
    items = items.map { |it| OpenStruct.new(it) }
    OpenStruct.new(collection: items, total_count: parsed_response['total_count'])
  end

  def asset_manifest(gallery_id: gallery_id, folder_id: folder_id, asset_id: asset_id)
    url = asset_manifest_url(asset_id)
    perform_get(url, gallery_id: gallery_id, folder_id: folder_id)
  end

  private

  def asset_manifest_url(asset_id)
    url_pattern = configatron.dmc.asset_manifest_url_pattern
    url_pattern % {
      dmc_host:   configatron.dmc.host,
      asset_id:   asset_id
    }
  end

  def perform_get(url, params = {})
    RestClient.get( url,
      params: params.merge(user_token: user_token),
      timeout: TIMEOUT_SEC,
      open_timeout: OPEN_TIMEOUT_SEC
    )
  rescue RestClient::RequestTimeout, Errno::ECONNREFUSED, SocketError => e
    raise ::Errors::Dmc::NoConnection.new(e.message)
  rescue RestClient::Exception => e
    raise ::Errors::Dmc::RemoteError.new(e.message)
  end

  def host
    configuration.options.find_by_code!('digital_media_center/host').value
  end

  def make_api_url(uri)
    "#{host}/api/v1/#{uri}.json"
  end

  def galleries_url
    make_api_url('galleries')
  end

  def folders_url
    make_api_url('folders')
  end

  def assets_url
    make_api_url('assets')
  end

  def structurize(response)
    items = JSON.parse(response)
    items.map { |it| ::Dmc::Dto.new(it) }
  end

  def user_token
    configuration.options.find_by_code!('digital_media_center/token').value
  end

  def configuration
    Configuration.find_by_code!('default')
  end
end
