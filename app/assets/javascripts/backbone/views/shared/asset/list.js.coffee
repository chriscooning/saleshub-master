class DMC.Views.Shared.Asset.List extends Backbone.View
  itemClass: DMC.Views.Shared.Asset.Item
  noAssetsMessageTmpl: JST['templates/shared/no_items/assets']

  initialize: (options = {})->
    window.loading_page = false
    @pagination_containers = $(".pagination-container")
    @foldersCollection = options['foldersCollection']
    @urlRoot = options['urlRoot']
    @setElement $("#assets-list")
    @listenTo @collection, 'add', @addOne
    @listenTo @collection, 'reset', @addAll
    @listenTo @collection, 'reset', @appendInfiniteScroll
    @listenTo @collection, 'remove', @reRenderList

    @collection.fetch
      reset: true
      error: (collection, xhr)->
        if xhr.responseJSON.code == 'password_required'
          new DMC.Views.Frontend.FolderAuthorizationModal(collection: collection).render()
        else
          new DMC.Views.Frontend.MediaAuthorizationModal(folder_id: collection.folder_id).render()

    @

  windowScrolled: =>
    scrollBeforePagination = $(document).height() - $(window).height() * 2
    if !window.loading_page && @collection.totalPages >= @collection.currentPage + 1 && $(window).scrollTop() > scrollBeforePagination
      window.loading_page = true
      @collection.requestNextPage
        update: true
        remove: false
        success: ->
          window.loading_page = false

  appendInfiniteScroll: =>
    $(window).on 'scroll', @windowScrolled

  render: ->
    @$el.empty()
    @

  addAll: ->
    @$el.empty()
    if @collection.length > 0
      @collection.each @addOne
    else
      @$el.append @noAssetsMessageTmpl()


  addOne: (model)=>
    folder = @foldersCollection.get(model.get('folder_id'))
    view = new @itemClass(model: model, folder: folder).render()
    @$el.append view.el


  reRenderList: ->
    @addAll()

