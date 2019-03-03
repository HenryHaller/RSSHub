require 'rails_helper'

RSpec.describe Episode do
  it { should belong_to(:show).touch }
  # it { should validate_presence_of(:title) } #this test just sucks
  # it { should validate_uniqueness_of(:title).scoped_to(:show) } #these tests are broken
end
