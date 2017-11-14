# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  is_active  :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Notification < ActiveRecord::Base
  has_many :viewings,
           dependent: :destroy

  validates :title,
            presence: true
  validates :body,
            presence: true
end
