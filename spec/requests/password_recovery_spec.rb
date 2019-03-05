require 'rails_helper'

RSpec.describe "User can recover password" do
  let!(:user) { create(:user) }
  let(:headers) { valid_headers }
  
  describe "user requests password recovery" do
    
    before do
      post "/auth/password_recovery_request", headers: headers, params: { email: user.email }.to_json
      @email_body = ActionMailer::Base.deliveries.last.body
      @pw_reset_link = @email_body.match(/by <a href="([^"]*)"/).captures.first
      @token = @pw_reset_link.match(/reset_token=(.*)/).captures.first
      @email = @pw_reset_link.match(/email=([^"]*)&/).captures.first
    end 

    context 'user can login with the old password' do
      before do
        post "/auth/login", params: { password: "password", email: user.email }.to_json, headers: {"Content-Type" => "application/json"}
      end
  
      it 'response is 200' do
        expect(response).to have_http_status(200)
      end
    end
  
    
    it 'gets 200' do
      expect(response).to have_http_status(200)
    end
    
    it 'sends an email with a token' do
      expect(@token).to be_instance_of(String)
    end
    
    it 'reset link includes email too' do
      expect(@email).to be_instance_of(String)
    end
    
    context "reset the password" do
      before do
        post "/auth/password_recovery_attempt", headers: headers, params: { new_password: "asdfasdf", recovery_token: @token, email: user.email }.to_json
      end
      
      it 'gets 200' do
        expect(response).to have_http_status(200)
      end

      it 'has helpful message' do
        expect(response.body).to match(/Password updated/)
      end

      context 'login with the old password' do
        before do
          post "/auth/login", params: { password: "password", email: user.email }.to_json, headers: {"Content-Type" => "application/json"} 
        end

        it 'response is 401' do
          expect(response).to have_http_status(401)
        end
      end
      
      context 'login with the new password' do
        before do
          post "/auth/login", params: { password: "asdfasdf", email: user.email }.to_json, headers: {"Content-Type" => "application/json"} 
        end
        
        it 'response is 200' do
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end