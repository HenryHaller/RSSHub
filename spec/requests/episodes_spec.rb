require 'rails_helper'

RSpec.describe 'Episodes API' do
  let!(:user) { create(:user) }
  let!(:show) { create(:show, users: [user]) }
  let!(:episodes) { create_list(:episode, 5, show: show)}
  let(:show_id) { show.id }
  let(:headers) { valid_headers }
  
  
  describe "GET /episodes" do
    before { get "/episodes/", headers: headers }
    
    context "We Can Get Episodes" do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
      
      it 'returns 5 episodes' do
        expect(json.size).to eq(5)
      end
      
      it 'every episode has a show title' do
        json.each do |episode|
          expect(episode["show_title"]).to be_a(String)
        end
      end
    end
  end
end
    