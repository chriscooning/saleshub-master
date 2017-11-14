Cyrax::Presenters::DecoratedCollection.class_eval do
  delegate :current_page, :total_entries, :total_pages, :per_page, :offset, to: :collection
end
