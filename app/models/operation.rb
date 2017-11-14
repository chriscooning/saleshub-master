# == Schema Information
#
# Table name: operations
#
#  id           :integer          not null, primary key
#  code         :string(255)
#  presentation :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Operation < ActiveRecord::Base
end
