module Manage
  class RolesController < BaseController

    def new
      respond_with resource.build
    end

    def create
      respond_with resource.create, location: manage_roles_path
    end

    def index
      respond_with resource.read_all
    end

    def edit
      respond_with resource.edit
    end

    def update
      respond_with resource.update, location: manage_roles_path
    end

    def destroy
      respond_with resource.destroy, location: manage_roles_path
    end

    private

    def resource
      @_resource ||= Roles::BaseResource.new(as: current_user, params: params)
    end
  end
end
