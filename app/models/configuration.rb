# == Schema Information
#
# Table name: configurations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  code       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Configuration < ActiveRecord::Base
  has_many :options, -> { order('configuration_options.created_at ASC') }
  accepts_nested_attributes_for :options,
                                allow_destroy: false,
                                reject_if: proc{ |attrs| attrs['id'].blank? }
end
