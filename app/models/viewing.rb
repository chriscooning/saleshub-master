# == Schema Information
#
# Table name: viewings
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  notification_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Viewing < ActiveRecord::Base
  belongs_to :user
  belongs_to :notification

  validates :user,
            presence: true
  validates :notification,
            presence: true
  validates :notification_id,
            uniqueness: {
              scope: :user_id
            }
end
