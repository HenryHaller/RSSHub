require 'rails_helper'
RSpec.describe "deleting a show for one user keeps it for others" do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let(:headers1) { valid_headers_for_id(user1.id) }
    let(:headers2) { valid_headers_for_id(user2.id) }
    let(:valid_attributes) { { rss_url: "http://localhost:3001/items.rss" }.to_json }


    context "both users subscribe" do
        before do
            post '/shows', headers: headers1, params: valid_attributes
            post '/shows', headers: headers2, params: valid_attributes
        end

        it 'there should be one show' do
            expect(Show.count).to eq(1)
        end

        it 'the show should have two users' do
            expect(Show.first.users.count).to eq(2)
        end

        context "first user deletes the show" do
            before do
                delete "/shows/#{Show.first.id}", headers: headers1
            end

            it 'there should still be one show' do
                expect(Show.count).to eq(1)
            end

            it 'the show should have 1 user' do
                expect(Show.first.users.count).to eq(1)
            end
        end
    end
end