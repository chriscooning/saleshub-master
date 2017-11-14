# == Schema Information
#
# Table name: configuration_options
#
#  id               :integer          not null, primary key
#  configuration_id :integer
#  code             :string(255)
#  name             :string(255)
#  value            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Configuration::Option < ActiveRecord::Base
  belongs_to :configuration
end
