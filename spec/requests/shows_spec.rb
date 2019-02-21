require 'rails_helper'

RSpec.describe "Shows API", type: :request do
  let!(:user) { create(:user) }
  # let!(:shows) { create_list(:show, 2) }
  let!(:shows) { create_list(:show, 2, users: [user]) }
  let(:show_id) { shows.first.id }

  describe 'GET /shows/' do
    before { get '/shows' }
    it 'returns shows' do
      expect(json).not_to be_empty
      expect(json.size).to eq(2)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /shows/:id' do
    before { get "/shows/#{show_id}" }

    context 'when the record exists' do
      it 'returns the show' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(show_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end


    context 'when the show does not exist' do
      let(:show_id) {100}

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Show/)
      end
    end

  end

  describe 'POST /shows' do
    let(:valid_attributes) { { rss_url: "http://localhost:3001/items.rss" } }
    context 'when the request is valid' do
      before { post '/shows', params: valid_attributes}

      it 'creates a show' do
        expect(json['rss_url']).to eq("http://localhost:3001/items.rss")
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before {post '/shows', params: {rss_url: "asdf"}}

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      it 'returns a validation failure message' do
        expect(response.body).to match(/This submission doesn't look like a valid url./)
      end
    end
  end

  describe 'DELETE /shows/:id' do
    before { delete "/shows/#{show_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

  end

end
