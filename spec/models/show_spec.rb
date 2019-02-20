require 'rails_helper'

RSpec.describe Show, type: :model do
  it { should have_many(:episodes).dependent(:destroy) }
  it { should have_and_belong_to_many(:users) }
  it { should validate_uniqueness_of(:rss_url).ignoring_case_sensitivity }
end
