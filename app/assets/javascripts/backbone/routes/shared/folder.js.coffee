class DMC.Routers.Shared.Folder extends Backbone.Router
  assetsListClass: DMC.Views.Shared.Asset.List
  assetShowClass: DMC.Views.Shared.Asset.Show

  routes:
    '!': 'index'
    '!folders/:id': 'showFolder'
    '!folders/:id/page/:page': 'showFolder'
    '!assets/:id': 'showAsset'
    '!search/:query': 'searchAssets'
    '!search/:query/page/:page': 'searchAssets'

  initialize: (options)->
    super
    @collection = options['collection']

  showFirstFolder: ->
    if @collection.length && !@folder_id
      @navigate("!folders/#{@collection.first().id}", trigger: true)

  index: ->
    @modal.close() if @modal

  showFolder: (id, page = 1)->
    folder = @collection.get(id)
    return false unless folder
    @folder_id = id
    @makeFolderActive(id)

    if @assetCollection is undefined || @assetCollection.folder_id != @folder_id
      @assetCollection = new DMC.Collections.Assets([], gallery_id: @collection.gallery_id, folder_id: id, folder: folder)

    @assetCollection.currentPage = parseInt(page)
    @assetsView = new @assetsListClass(
      collection: @assetCollection,
      foldersCollection: @collection,
      urlRoot: "#!folders/#{@folder_id}"
    ).render()

  searchAssets: (query, page = 1)->
    return unless query
    @assetCollection = new DMC.Collections.Assets([], gallery_id: @collection.gallery_id, folder_id: 0, query: query)
    @assetCollection.currentPage = parseInt(page)
    @assetCollection.query = query
    @assetsView = new @assetsListClass(
      collection: @assetCollection,
      foldersCollection: @collection,
      urlRoot: "#!search/#{query}"
    ).render()

  makeFolderActive: (id)->
    $('#folders-list li.active').removeClass('active')
    $("#folders-list a[data-id='#{id}']").parent().addClass('active')

  showAsset: (id)->
    return unless @assetCollection
    if asset = @assetCollection.get(id)
      @modal = new @assetShowClass(model: asset).render()
      @listenToOnce @modal, 'destroyed', => @navigate("!folders/#{@folder_id}")

