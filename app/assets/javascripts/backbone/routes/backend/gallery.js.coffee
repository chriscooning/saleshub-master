class DMC.Routers.Backend.Gallery extends Backbone.Router
  routes:
    '!': 'index'
    '!new': 'new'

  initialize: (options)->
    @collection = options['collection']

  index: ->
    @modal.close() if @modal

  new: ->
    model = new DMC.Models.Gallery()
    @collection.add model
    @modal = new DMC.Views.Backend.Gallery.Form(model: model).render()
    @listenToOnce @modal, 'destroyed', => @navigate('!')