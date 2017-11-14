class AssetSerializer
  include ActiveSerializer::SerializableObject

  serialization_rules do |assets|
    attributes :total_count

    resources :result, assets.collection do |assets|
      attributes :id, :title, :description, :asset_type, :document_type,
             :folder_id, :file_url, :is_image, :thumb_url, :medium_url,
             :is_video, :quicklink_hash, :quicklink_url, :quicklink_valid_to,
             :quicklink_downloadable, :embedding_hash, :is_pdf, :pdf_preview_url,
             :video_urls, :smil_manifest, :downloadable, :type_icon_url,
             :alternative_thumbnail_url, :is_processed
    end
  end
end
