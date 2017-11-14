$ ->
  return unless $("#search").length > 0

  $("#search-container form").on 'submit', ->
    query = $("#search").val()
    return false unless query
    Backbone.history.navigate("!search/#{query}", trigger: true)
    false

