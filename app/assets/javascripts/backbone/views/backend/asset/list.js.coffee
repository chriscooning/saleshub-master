class DMC.Views.Backend.Asset.List extends DMC.Views.Shared.Asset.List
  itemClass: DMC.Views.Backend.Asset.Item

  appendInfiniteScroll: => true

  addAll: ->
    @$el.empty()
    @renderPagination()
    if @collection.length > 0
      @collection.each @addOne
    else
      @$el.append @noAssetsMessageTmpl()

  renderPagination: ->
    @pagination_containers.empty()
    pg = new DMC.Views.Shared.Pagination(collection: @collection, urlRoot: @urlRoot).render()
    @pagination_containers.append pg.el