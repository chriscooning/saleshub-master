module ApplicationHelper
  def paginate(collection)
    will_paginate(collection, renderer: PaginationListLinkRenderer)
  end
end
