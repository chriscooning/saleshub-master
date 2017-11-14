class News::BaseSerializer < Cyrax::Serializer
  include ActionView::Helpers::TextHelper

  attributes :id,
             :title,
             :link,
             :created_by_id

  attribute :is_external do |resource|
    resource.external?
  end

  attribute :preview do |resource|
    truncate(resource.body, length: 200)
  end

  attribute :published_at do |resource|
    resource.published_at.strftime("%b #{resource.published_at.day.ordinalize}, %Y")
  end

  attribute :image_url do |resource|
    if resource.image.present?
      resource.image.to_s
    else
      nil
    end
  end

  attribute :is_destroyed do |resource|
    resource.destroyed?
  end
end