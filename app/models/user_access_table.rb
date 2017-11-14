# == Schema Information
#
# Table name: user_access_tables
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  permissions :text             not null
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_user_access_tables_on_user_id  (user_id)
#

class UserAccessTable < ActiveRecord::Base
  belongs_to :user
  serialize :permissions, Hash

  def permit?(resource_name, action_name)
    permissions.present? &&
    permissions[resource_name].present? &&
    permissions[resource_name].include?(action_name)
  end
end
