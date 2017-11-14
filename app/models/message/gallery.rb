# == Schema Information
#
# Table name: message_galleries
#
#  id            :integer          not null, primary key
#  message_id    :integer
#  created_by_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Message::Gallery < ActiveRecord::Base
  belongs_to :message
  belongs_to :created_by,
             class_name: User
  has_many :images,
           class_name: Message::Gallery::Image,
           foreign_key: :message_gallery_id,
           dependent: :destroy
end
