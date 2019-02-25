require 'rails_helper'

RSpec.describe "Aware of new Episodes" do
  let!(:user) { create(:user) }
  let!(:show) { create(:show, users: [user], rss_url: "http://localhost:3001/items/") }
  let!(:title) { "Show created #{Time.now}"}
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
      before { HTTP.post "http://localhost:3001/items", params: { title: title} }

      context 'scrape new episode' do
        before { UpdateShowsJob.perform_now }

        context 'User re-checks feed. New episode is present' do
          before { get "/episodes/", headers: headers}
          # before { @second_count = json.size }

          it 'has more episodes than it did before' do
            expect(json.size).to be > @initial_count
          end

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end

          it 'highest show title is our expected title' do
            expect(json.first["title"]).to eq(title)
          end
        end
      end
    end
  end
end
