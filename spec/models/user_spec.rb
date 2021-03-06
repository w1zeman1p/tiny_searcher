# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  external_id     :string
#  name            :string
#  alias           :string
#  active          :boolean
#  verified        :boolean
#  shared          :boolean
#  locale          :string
#  timezone        :string
#  last_login_at   :datetime
#  email           :string
#  phone           :string
#  signature       :string
#  organization_id :bigint(8)
#  suspended       :boolean
#  role            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_organization_id  (organization_id)
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should belong_to(:organization).optional }
  it { should have_many(:tags) }
end
