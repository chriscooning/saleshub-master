class DMC.Views.Frontend.MediaAuthorizationModal extends DMC.Views.Shared.Form.Base
  template: JST['templates/frontend/media_authorization_modal']

  events:
    'hidden.bs.modal': 'afterClose'
    'click a.request': 'requestAuthorization'

  initialize: (options)->
    super
    @target_type = if options['folder_id'] then 'Folder' else 'Gallery'
    @target_id = options['folder_id'] || options['gallery_id']
    @

  render: ->
    data =
      target_id: @target_id
      target_type: @target_type

    @$el.html @template(data)
    @$el.modal()
    @

  requestAuthorization: ->
    $.ajax 
      url:"/authorizations",
      method: 'POST'
      data:
        authorization:
          target_id: @target_id
          target_type: @target_type
        authenticity_token: $("meta[name=csrf-token]").attr('content')
      dataType: 'json'
      success: =>
        @close()
        window.renderFlashMessage('notice', 'You request will be processed soon!')