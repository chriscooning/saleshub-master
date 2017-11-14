# == Schema Information
#
# Table name: roles
#
#  id           :integer          not null, primary key
#  code         :string(255)
#  presentation :string(255)
#  is_common    :boolean          default(FALSE)
#  is_default   :boolean          default(FALSE)
#  created_at   :datetime
#  updated_at   :datetime
#

class Role < ActiveRecord::Base
  has_and_belongs_to_many :rules

  validates :presentation,
            presence: true,
            uniqueness: true,
            format: {
              with: /[a-z]+/i
            }
  validates :code,
            presence: true,
            uniqueness: true,
            format: {
              with: /[a-z\-]+/
            }
  validates :is_default,
            uniqueness: true,
            if: :is_default?
end
