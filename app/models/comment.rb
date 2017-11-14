# == Schema Information
#
# Table name: comments
#
#  id            :integer          not null, primary key
#  message_id    :integer
#  parent_id     :integer
#  created_by_id :integer
#  content       :text
#  created_at    :datetime
#  updated_at    :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :message
  belongs_to :parent,
             class_name: Comment
  belongs_to :created_by,
             class_name: User
  has_many :children,
           class_name: Comment,
           inverse_of: :parent,
           foreign_key: :parent_id

  validates :message,
            presence: true
  validates :created_by,
            presence: true
  validates :content,
            presence: true
  validate do
    if parent.present? && parent.parent.present?
      unless parent.parent.parent.blank?
        errors.add(:base, 'Maximum thread level is reached')
      end
    end
  end
  validate do
    if parent.present? && !parent.message.eql?(message)
      errors.add(:base, 'Wrong parent or message')
    elsif parent.present? && parent.parent.present? && !parent.parent.message.eql?(message)
      errors.add(:base, 'Wrong parent or message')
    end
  end

end
