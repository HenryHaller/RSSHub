require 'rails_helper'

RSpec.describe "System works when subscribing a url to second user" do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let(:headers1) { valid_headers_for_id(user1.id) }
    let(:headers2) { valid_headers_for_id(user2.id) }
    
    context "First user subscribes." do
        let(:valid_attributes) { { rss_url: "http://localhost:3001/items.rss" }.to_json }
        context 'first user subscribing' do
            before { post '/shows', headers: headers1, params: valid_attributes}
            
            it 'returns status code 201' do
                expect(response).to have_http_status(201)
            end
            
            it 'user model1 has 1 show' do
                expect(user1.shows.count).to eq(1)
            end
            context "first user checks subscriptions" do
                before { get '/shows', headers: headers1 }
                
                it 'returns status code 200' do
                    expect(response).to have_http_status(200)
                end
                
                it 'first user has one show' do
                    expect(json.length).to eq(1)
                end
            end  
            context 'second user subscribing' do
                before { post '/shows', headers: headers2, params: valid_attributes}
                
                it 'returns status code 201' do
                    expect(response).to have_http_status(201)
                end
                it 'user model1 has 1 show' do
                    expect(user1.shows.count).to eq(1)
                end
                
                it 'user model2 has 1 show' do
                    expect(user2.shows.count).to eq(1)
                end
                
                it 'the system should only have 1 show' do
                    expect(Show.count).to eq(1)
                end
                
                context "first user checks subscriptions" do
                    before { get '/shows', headers: headers1 }
                    
                    it 'returns status code 200' do
                        expect(response).to have_http_status(200)
                    end
                    
                    it 'first user has one show' do
                        expect(json.length).to eq(1)
                    end
                end
                context "second user checks subscriptions" do
                    before { get '/shows', headers: headers2 }
                    
                    it 'returns status code 200' do
                        expect(response).to have_http_status(200)
                    end
                    
                    it 'second user has one show' do
                        expect(json.length).to eq(1)
                    end
                end
            end
        end
    end
end