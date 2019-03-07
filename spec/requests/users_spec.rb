# spec/requests/users_spec.rb
require 'rails_helper'


RSpec.describe 'Users API', type: :request do
  let(:user) { build(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    attributes_for(:user, password_confirmation: user.password)
  end

  # User signup test suite
  describe 'POST /signup' do
    context 'when valid request' do
      before do
         post '/signup', params: valid_attributes.to_json, headers: headers
         @email_body = ActionMailer::Base.deliveries.last.body
         @activation_link = @email_body.match(/account <a href="([^"]*)"/).captures.first
         @activation_token = @activation_link.match(/token=([^&]*)&/).captures.first
         @activation_email = @activation_link.match(/email=(.*)/).captures.first
        #  puts @activation_link
        #  puts @activation_email
        #  puts @activation_token
      end

      #TO DO: add authentication failure mode for pending activation

      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      # it 'returns an authentication token' do
      #   expect(json['auth_token']).not_to be_nil
      # end

      it 'email message thanks them for registering' do
        expect(@email_body).to match(/<h1>Thank You for registering/)
      end

      context 'activate the new user' do
        before { post "/auth/activate?activation_token=#{@activation_token}&email=#{@activation_email}" }

        it 'gets OK response' do
          expect(response).to have_http_status(200)
        end

        it 'has OK message' do
          expect(response.message).to eq("OK")
        end
      end
    end

    context 'when invalid request' do
      before { post '/signup', params: {}, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message' do
        expect(json['message'])
          .to match(/Validation failed: Password can't be blank, Email can't be blank/)
      end
    end
  end
end

