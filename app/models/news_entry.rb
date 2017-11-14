# == Schema Information
#
# Table name: news_entries
#
#  id            :integer          not null, primary key
#  news_type     :integer
#  title         :string(800)
#  body          :text
#  created_at    :datetime
#  updated_at    :datetime
#  link          :string(2048)
#  link_hashcode :integer
#  pub_date      :datetime
#  guid          :string(1024)
#  image         :string(255)
#  created_by_id :integer
#
# Indexes
#
#  index_news_entries_on_link_hashcode  (link_hashcode)
#  index_news_entries_on_pub_date       (pub_date)
#

class NewsEntry < ActiveRecord::Base
  module Types
    INTERNAL = 0
    EXTERNAL = 1
    ALL = [INTERNAL, EXTERNAL]
  end

  module Limits
    TITLE = 120
    BODY  = 800
    LINK  = 2048
  end

  belongs_to :created_by,
             class_name: 'User'

  mount_uploader :image, NewsEntry::ImageUploader

  validates :news_type, inclusion: Types::ALL
  validates :body, :title, presence: true
  validates :link, :link_hashcode, presence: true, if: :external?

  scope :internal, -> do
    where(news_type: Types::INTERNAL).order('pub_date DESC, created_at DESC')
  end
  scope :external, -> do
    where(news_type: Types::EXTERNAL).order('pub_date DESC, created_at DESC')
  end

  def internal?
    self.news_type == Types::INTERNAL
  end
  def external?
    self.news_type == Types::EXTERNAL
  end

  class << self
    def accessible_by(user, operation)
      return all if user.is_admin?

      rules = user.allow_rules_for('news')

      rules = rules.select{ |rule| rule.operation.code.eql?(operation.to_s) }

      if rules.any?(&:is_global?)
        all
      else
        where(created_by_id: user.id)
      end
    end
  end
end
