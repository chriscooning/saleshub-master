class DMC.Models.Folder extends DMC.Libs.BaseModel
  modelAttributes: ['id', 'name', 'hide_folder', 'enable_credentials', 'enable_password', 'default_per_page']
  accessibleAttributes: ['name', 'hide_folder', 'enable_credentials', 'enable_password',
                        'password', 'hide_title', 'hide_description', 'gallery_id', 'default_per_page']
  paramRoot: 'folder'

  is_title_visible: -> !@get('hide_title')

  is_description_visible: -> !@get('hide_description')

class DMC.Collections.Folders extends Backbone.Collection
  model: DMC.Models.Folder

  comparator: 'position'

  initialize: (models, options)->
    super
    @gallery_id = options['gallery_id']
    @

  url: -> window.subdomainUrl("/galleries/#{@gallery_id}/folders")