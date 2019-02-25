require 'rails_helper'

RSpec.describe "Aware of new Episodes" do
  let!(:user) { create(:user) }
  let!(:show) { create(:show, users: [user], rss_url: "http://localhost:3000/items.rss") }
  let(:headers) { valid_headers }

  describe "User Checks Feed" do
    before { get "/episodes/", headers: headers}
    before { @initial_count = json.size }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'initial count is a reasonable amount of episodes' do
      expect(@initial_count).to be_instance_of(Integer)
      expect(@initial_count).to be >= 0
    end

    context 'publish new episode' do
      before { HTTP.post "http://localhost:3001/items" }

      context 'scrape new episode' do
        before { UpdateShowsJob.perform_now }

        context 'User re-checks feed. New episode is present' do
          before { get "/episodes/", headers: headers}
          before { @second_count = json.size }

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end

          it 'second count is initial count + 1' do
            expect(@second_count).to eq(@initial_count + 1)
          end

        end
      end
    end
  end
end
