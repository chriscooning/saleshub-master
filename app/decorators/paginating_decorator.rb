class PaginatingDecorator < Draper::CollectionDecorator
  # support for will_paginate
  delegate :current_page, :total_entries, :total_pages, :per_page, :offset

  def from
    total_entries - offset - count + 1
  end

  def to
    total_entries - offset
  end
end
