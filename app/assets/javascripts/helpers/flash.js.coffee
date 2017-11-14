Flash =
  audio_file_url: null
  history: {}

  show: (options) ->
    if options.external_id && Flash.history[options.external_id]
      $.gritter.remove(Flash.history[options.external_id])
      Flash.history[options.external_id] = undefined

    internal_id = $.gritter.add({
      title: options.title
      text: options.body
      position: options.position || 'bottom-left'
      sticky: options.sticky || false
      time: options.sticky || 10000
      after_close: options.after_close
    })

    if options.external_id
      Flash.history[options.external_id] = internal_id

    @audio_file().play()

  permanent: (title, body, external_id, callback_url) ->
    @show
      title: title
      body: body
      external_id: external_id
      sticky: true
      after_close: ->
        $.ajax
          url: callback_url
          data:
            _method: 'put'
          type: 'post'

  temporary: (title, body) ->
    @show
      title: title
      body: body
      sticky: false
      time: 10000

  notice: (title, body, external_id, callback_url) ->
    @permanent(title, body, external_id, callback_url)

  audio_file: ->
    @_audio_file ||= new Audio(Flash.audio_file_url)

  delete: (external_id) ->
    if external_id && Flash.history[external_id]
      $.gritter.remove(Flash.history[external_id])
      Flash.history[external_id] = undefined

window.Flash = Flash
