# == Schema Information
#
# Table name: access_table_templates
#
#  id          :integer          not null, primary key
#  permissions :text             not null
#  created_at  :datetime
#  updated_at  :datetime
#

class AccessTableTemplate < ActiveRecord::Base
  serialize :permissions, Hash
end
