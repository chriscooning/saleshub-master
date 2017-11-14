class DMC.Models.Gallery extends DMC.Libs.BaseModel
  modelAttributes: ['id', 'name', 'visible', 'enable_credentials', 'enable_password', 'enable_invitation_credentials']
  accessibleAttributes: ['name', 'visible', 'enable_credentials', 'enable_password', 'enable_invitation_credentials',
                         'password', 'url', 'show_first']
  methodAttributes: ['url']

  paramRoot: 'gallery'

  defaults:
    visible: true

class DMC.Collections.Galleries extends Backbone.Collection
  model: DMC.Models.Gallery

  url: -> window.subdomainUrl("/galleries")