# == Schema Information
#
# Table name: messages
#
#  id            :integer          not null, primary key
#  author_name   :string(255)
#  body          :text             not null
#  message_type  :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#  title         :string(120)      not null
#  is_anonymous  :boolean          default(TRUE)
#  is_published  :boolean          default(TRUE)
#  is_featured   :boolean          default(FALSE)
#  position      :integer          default(0)
#  created_by_id :integer
#  token         :string(255)
#

class Message < ActiveRecord::Base
  module Limits
    TITLE = 120
    BODY  = 9000
    FEATURED = 3
  end
  module Types
    BASIC    = 0
    BRIEFING = 1
    WHATS_UP = 2
  end

  include Bootsy::Container

  belongs_to :created_by,
             class_name: User
  has_one :gallery,
          class_name: Message::Gallery
  has_many :comments, -> { where(parent_id: nil).includes(children: :children) }

  validates :author_name,
            :body,
            :message_type,
            :title,
            presence: true
  validates :position,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1
            }
  validates :message_type,
            inclusion: [ Types::BASIC, Types::BRIEFING ]
  validate do
    if is_featured? && Message.where(message_type: message_type).featured.published.where('id != ?', id).count >= Limits::FEATURED
      errors.add(:is_featured, 'can not be checked. Limits are reached.')
    end
  end

  before_validation on: :create do
    maximum = Message.where(message_type: message_type).maximum(:position) || 0
    self.position = maximum + 1
  end

  before_save on: :create do
    self.token = Digest::MD5.hexdigest("#{message_type}#{title}#{Time.now.to_i}")
  end

  def created_by?(user)
    created_by.eql?(user)
  end

  def whats_up?
    message_type.eql?(Types::WHATS_UP)
  end

  class << self
    def published
      where(is_published: true)
    end

    def featured
      where(is_featured: true)
    end

    def by_position
      order(position: :desc)
    end

    def by_creation
      order(created_at: :desc)
    end

    def accessible_by(user, operation)
      return all if user.is_admin?

      operands = ['message', 'briefing', 'whats_up']

      rules = user.allow_rules_for(operands)

      rules = rules.select{ |rule| rule.operation.code.eql?(operation.to_s) }

      queries = []

      rules.group_by(&:operand).each do |operand, rules|
        sql = "messages.message_type = #{operands.index(operand.code)}"
        unless rules.any?(&:is_global?)
          sql += " AND messages.created_by_id = #{user.id}"
        end

        queries << sql
      end

      query = queries.join(' OR ')

      where(query)
    end
  end
end
