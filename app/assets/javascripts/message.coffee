window.Message = class Message
  constructor: (@$element) ->
    @id = @$element.data('id')
    @url = @$element.data('url')

    @setVariables()
    @bindEvents()

  setVariables: () ->
    @inputs =
      status: @$element.find('select[name="message[status]"]')
      is_featured: @$element.find(':checkbox[name="message[is_featured]"]')

  bindEvents: () ->
    @inputs.status.bind 'change', () => @updateStatus()
    @inputs.is_featured.bind 'change', () => @updateIsFeatured()

  disableFields: () ->
    @$element.find(':input').prop('disabled', true)

  updateStatus: () ->
    @disableFields()
    switch @inputs.status.val()
      when 'Draft' then @update({ is_published: false })
      when 'Published' then @update({ is_published: true })

  updateIsFeatured: () ->
    @disableFields()
    @update({ is_featured: @inputs.is_featured.is(':checked') })

  update: (attributes = {}) ->
    $.ajax({
      url: @url
      type: 'post'
      dataType: 'json'
      data:
        _method: 'put'
        message: attributes
    }).done(@updated)

  updated: (data) =>
    @$element.html($(data.html).html())
    @$element.removeClass('danger')
    @$element.removeClass('info')
    @$element.addClass('danger') if $(data.html).hasClass('danger')
    @$element.addClass('info') if $(data.html).hasClass('info')
    @setVariables()
    @bindEvents()

