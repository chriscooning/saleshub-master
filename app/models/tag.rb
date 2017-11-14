# == Schema Information
#
# Table name: tags
#
#  id   :integer          not null, primary key
#  name :string(255)
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#

class Tag < ActiveRecord::Base
end
