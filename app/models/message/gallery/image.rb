# == Schema Information
#
# Table name: message_gallery_images
#
#  id                 :integer          not null, primary key
#  message_gallery_id :integer
#  file               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Message::Gallery::Image < ActiveRecord::Base
  belongs_to :gallery,
             class_name: Message::Gallery,
             foreign_key: :message_gallery_id

  mount_uploader :file, Message::Gallery::ImageUploader
end
