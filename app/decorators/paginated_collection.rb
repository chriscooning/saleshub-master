class PaginatedCollection < AppDecorator
  delegate_all
  # support for will_paginate
  attr_accessor :current_page, :total_entries, :per_page

  def offset
    @_offset ||= current_page * per_page
  end

  def total_pages
    @_total_pages ||= total_entries / per_page
  end
end
