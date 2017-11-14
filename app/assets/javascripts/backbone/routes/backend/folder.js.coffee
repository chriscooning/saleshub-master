class DMC.Routers.Backend.Folder extends DMC.Routers.Shared.Folder
  assetsListClass: DMC.Views.Backend.Asset.List
  assetShowClass: DMC.Views.Backend.Asset.Show

  routes: _.extend({
      '!manager': 'manageFolders'
      '!uploader': 'uploader'
      '!edit/:id': 'edit'
      '!folders/:id/sort': 'sortAssets'
      '!assets/:id/edit': 'editAsset'
      '!assets/:id/destroy': 'destroyAsset'
      '!assets/:id/quicklink': 'assetQuickLink'
      '!assets/:id/analytics': 'assetAnalytics'
      '!assets/:id/embedding': 'assetEmbedding'
    }, DMC.Routers.Shared.Folder.prototype.routes)

  edit: (id)->
    return unless parseInt(id)
    @modal.close(silently: true) if @modal
    model = @collection.get id
    @modal = new DMC.Views.Backend.Folder.Form(model: model).render()
    @listenToOnce @modal, 'destroyed', => @navigate("!folders/#{id}", trigger: id != @folder_id)


  manageFolders: ->
    @modal = new DMC.Views.Backend.Folder.Manager(collection: @collection).render()
    @listenToOnce @modal, 'destroyed', => @navigateToActiveFolder()

  uploader: ->
    @modal = new DMC.Views.Backend.Folder.Uploader(folders: @collection).render()
    @listenToOnce @modal, 'destroyed', => @navigateToActiveFolder()

  editAsset: (id)->
    return unless @assetCollection && asset = @assetCollection.get(id)
    @modal = new DMC.Views.Backend.Asset.Form(model: asset, folders: @collection).render()
    @listenToOnce @modal, 'destroyed', => @navigate("!folders/#{@folder_id}")

  assetQuickLink: (id)->
    return unless @assetCollection && asset = @assetCollection.get(id)
    @modal = new DMC.Views.Backend.Asset.QuickLinkModal(model: asset, folders: @collection).render()
    @listenToOnce @modal, 'destroyed', => @navigate("!folders/#{@folder_id}")

  assetAnalytics: (id)->
    return unless @assetCollection && asset = @assetCollection.get(id)
    @modal = new DMC.Views.Backend.Asset.AnalyticsModal(model: asset, folders: @collection).render()
    @listenToOnce @modal, 'destroyed', => @navigate("!folders/#{@folder_id}")

  assetEmbedding: (id)->
    return unless @assetCollection && asset = @assetCollection.get(id)
    return unless asset.get('is_video')
    @modal = new DMC.Views.Backend.Asset.EmbeddingModal(model: asset, folders: @collection).render()
    @listenToOnce @modal, 'destroyed', => @navigate("!folders/#{@folder_id}")

  sortAssets: (folder_id)->
    return unless @collection && folder = @collection.get(folder_id)
    @modal = new DMC.Views.Backend.Modals.SortAssets(folder: folder).render()
    @listenToOnce @modal, 'destroyed', => @navigate("!folders/#{folder_id}", trigger: true)

  navigateToActiveFolder: ->
    if @folder_id
      @navigate("!folders/#{@folder_id}")
    else
      @navigate("!")

