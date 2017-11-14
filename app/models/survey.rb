# == Schema Information
#
# Table name: surveys
#
#  id                      :integer          not null, primary key
#  author_id               :integer          not null
#  customer_name           :text             not null
#  phone                   :string(255)
#  address                 :text
#  zipcode                 :string(255)
#  city                    :string(255)
#  state                   :string(255)
#  summary                 :text             not null
#  last_interaction_rating :integer          not null
#  created_at              :datetime
#  updated_at              :datetime
#  phone_extension         :string(255)
#
# Indexes
#
#  index_surveys_on_author_id  (author_id)
#  index_surveys_on_state      (state)
#  index_surveys_on_zipcode    (zipcode)
#

class Survey < ActiveRecord::Base
  validates :author_id, :customer_name, :summary, :last_interaction_rating, presence: true
  validates :state, inclusion: ::Services::Geo.us_state_codes, if: :state?
  validates :last_interaction_rating, :numericality => { :greater_than => 0, :less_than_or_equal_to => 5 }
  validates :phone, format: /\d{3}[ ]{1}\d{3}[ ]{1}\d{4}/, if: :phone?
  validates :zipcode, format: /\d{5}/, if: :zipcode?
  validates :phone_extension, format: /\d{6}/, if: :phone_extension?

  belongs_to :author, class_name: 'User'
end
