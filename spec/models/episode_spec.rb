require 'rails_helper'

RSpec.describe Episode do
  it { should belong_to(:show).touch }
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title).scoped_to(:show) }
end
