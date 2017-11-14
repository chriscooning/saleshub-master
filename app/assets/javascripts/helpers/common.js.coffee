$ ->
  $('#side-menu-toggle').sidr()

  $('.notifications-toggle').on 'click', ->
    $(this).parent().toggleClass "active"
    $('.notifications-container').toggle()
    false;