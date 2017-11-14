# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string(255)
#  last_name              :string(255)
#  role                   :integer
#  is_active              :boolean
#  role_id                :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  module Roles
    ADMIN = 0
    USER  = 1
    MANAGER = 2
  end
  module Permissions
    DEFAULT = {
      messages:  [:read],
      surveys:   [:read],
      news:      [:read],
      briefings: [:read],
      whats_ups: [:read]
    }
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
         :validatable, :registerable

  has_one  :access_table, class_name: 'UserAccessTable', dependent: :destroy
  has_many :surveys, foreign_key: 'author_id'
  has_many :viewings
  belongs_to :role
  has_and_belongs_to_many :rules

  scope :users, -> (without: nil) do
    criteria = joins(:role).where(roles: { code: 'user' })
    criteria = criteria.where('id <> ?', without) if without.present?
    criteria.order('created_at DESC')
  end

  scope :admins, joins(:role).where(roles: { code: 'admin' })

  scope :without, -> (user) do
    where('id <> ?', user.id)
  end

  scope :without_admins, joins(:role).where.not(roles: { code: 'admin' })

  def is_admin?
    role.code.eql?('admin')
  end

  def is_manager?
    role.code.eql?('manager')
  end

  def is_user?
    role.code.eql?('user')
  end

  def activate
    update_attribute(:is_active, true)
  end

  def deactivate
    update_attribute(:is_active, false)
  end

  def active_for_authentication?
    super && is_active?
  end

  def inactive_message
    if !is_active?
      :not_approved
    else
      super
    end
  end

  def allow_rules_for(operands)
    role_rules = role.rules.includes(:operation, :operand).by_operand(operands)
    user_rules = rules.includes(:operation, :operand).by_operand(operands)

    allow_rules = []

    role_rules.each do |role_rule|
      unless user_rules.any?{ |user_rule| user_rule.opposite?(role_rule) }
        allow_rules << role_rule
      end
    end

    allow_rules << user_rules.select(&:is_allow?)

    allow_rules.flatten.uniq
  end
end
