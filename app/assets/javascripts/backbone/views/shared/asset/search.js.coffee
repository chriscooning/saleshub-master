class DMC.Views.Shared.Asset.Search extends Backbone.View

  events:
    'click btn': 'startSearch'

  startSearch: ->
    query = $("#search").val()
    

