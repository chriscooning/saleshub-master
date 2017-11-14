class DMC.Views.Shared.Asset.Item extends Backbone.View
  className: 'col-md-3 asset-item'
  template: JST['templates/frontend/assets/item']

  events:
    'click .delete': 'delete'

  initialize: (options)->
    super
    @folder = options['folder']
    @model.view = @
    @listenTo @model, 'change', @render
    @listenTo @model, 'destroy', @remove
    @

  render: ->
    attributes = _.extend @model.attributes,
      is_title_visible: @folder.is_title_visible()
      is_description_visible: @folder.is_description_visible()
    @$el.html @template(attributes)
    @

  delete: ->
    @model.destroy() if confirm("Are you sure you want to delete this file? ALL analytics information, quicklinks etc. related to the associated asset will be deleted ")
    false

  remove: ->
    @stopListening()
    @$el.remove()