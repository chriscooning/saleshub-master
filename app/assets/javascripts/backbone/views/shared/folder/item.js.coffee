class DMC.Views.Shared.Folder.Item extends Backbone.View
  tagName: 'li'
  className: 'folder-item'
  template: JST['templates/shared/folder/item']

  events:
    'click a': 'makeActive'
    'click .edit': 'edit'
    'click .delete': 'delete'
    'click span': 'editFolder'

  initialize: (options)->
    super
    @model.view = @
    @listenTo @model, 'change', @render
    @listenTo @model, 'destroy', @delete
    @

  makeActive: ->
    @$el.parent().find('.active').removeClass('active')
    @$el.addClass('active')

  render: ->
    @$el.html @template(@model.attributes)
    @

  edit: ->
    new DMC.Views.Backend.Gallery.Form(model: @model).render()

  delete: ->
    @stopListening()
    @$el.remove()
    @model.destroy()

  editFolder: ->
    Backbone.history.navigate("!edit/#{@model.get('id')}", trigger: true)
    false