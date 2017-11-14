class DMC.Views.Shared.Asset.Show extends Backbone.View
  className: 'modal fade'
  template: JST['templates/shared/assets/show']

  events:
    'shown.bs.modal': 'afterOpening'
    'hidden.bs.modal': 'afterClose'

  render: ->
    $("body").addClass('modal-open')
    @$el.html @template(@model.withMethodAttribures())
    @$el.addClass('pdf-preview') if @model.get('is_pdf')
    @$el.modal()
    @

  close: (options = {silently: false})->
    @silently = options['silently']
    @$el.modal('hide')

  afterClose: ->
    $("body").removeClass('modal-open')
    @$el.remove()
    @trigger('destroyed') unless @silently

  afterOpening: ->
    @modalOpened()
    if @model.get('is_pdf')
      pdfObject = new PDFObject(url: @model.get('pdf_preview_url')).embed('pdf-preview')
      return

    if !!@model.get('is_video') && !!@model.get('processed')
      jwplayer("clipplayer").setup
        playlist: [
          image: @model.get('thumb_url')
          sources: [{
              file: @model.smil_manifest()
            },{
              file: @model.get('m3u8_url')
            },{
              file: @model.get('video_urls')['mp4_360p']
            }
          ]
        ]
        aspectratio: '16:9'
        flashplayer: "/jwplayer.flash.swf"
        primary: "flash"
        width: '100%'
      jwplayer("clipplayer").onComplete => @videoWatched()

  modalOpened: -> @
    # only relevant at DMC
    #window.trackEvent("modal_opened", @model.get('id'))

  videoWatched: -> @
    # only relevant at DMC
    #window.trackEvent("video_watched", @model.get('id'))