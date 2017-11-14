class Users::BaseResource < Cyrax::Resource
  resource :user
  decorator Users::BaseDecorator

  repository :find_all do
    User.without(accessor).paginate(pagination_params)
  end
end
