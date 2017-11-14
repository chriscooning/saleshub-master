class Admin::BaseController < ApplicationController
  private

  def current_ability
    AdminAbility.new(current_user)
  end
end
