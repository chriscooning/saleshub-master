# == Schema Information
#
# Table name: operands
#
#  id           :integer          not null, primary key
#  code         :string(255)
#  presentation :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Operand < ActiveRecord::Base
  has_and_belongs_to_many :operations
end
