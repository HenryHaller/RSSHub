require 'rails_helper'

RSpec.describe "User can change password" do
  let!(:user) { create(:user) }
  let(:headers) { valid_headers }

  context 'user can login with the old password' do
    before do
      post "/auth/login", params: { password: "password", email: user.email }.to_json, headers: {"Content-Type" => "application/json"}
    end

    it 'response is 200' do
      expect(response).to have_http_status(200)
    end

    context 'user changes password' do
      before do
        post "/auth/update_password", params: { new_password: "asdfasdfasdf", email: user.email }.to_json, headers: valid_headers
      end

      it 'response is 200' do
        expect(response).to have_http_status(200)
      end

      context 'user can login with the new password' do
        before do
          post "/auth/login", params: { password: "asdfasdfasdf", email: user.email }.to_json, headers: {"Content-Type" => "application/json"}
        end
    
        it 'response is 200' do
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end