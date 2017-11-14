class News::BaseResource < Cyrax::Resource
  resource :news_entry
  decorator News::BaseDecorator
  serializer News::BaseSerializer
end