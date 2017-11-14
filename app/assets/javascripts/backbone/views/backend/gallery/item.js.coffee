class DMC.Views.Backend.Gallery.Item extends Backbone.View
  tagName: 'tr'
  template: JST['templates/backend/gallery/item']

  events:
    'click .edit': 'edit'
    'click .delete': 'delete'

  initialize: (options)->
    super
    @model.view = @
    @listenTo @model, 'sync', @render
    @listenTo @model, 'destroy', @delete
    @

  render: ->
    @$el.html @template(@model.asJSON())
    @$el.data('id', @model.get('id'))
    @

  edit: ->
    new DMC.Views.Backend.Gallery.Form(model: @model).render()

  delete: ->
    if @model.isNew() || confirm("Are you sure you want to delete this gallery? All assets will also be deleted!")
      @stopListening()
      @$el.remove()
      @model.destroy()