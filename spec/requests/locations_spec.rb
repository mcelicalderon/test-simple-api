require 'rails_helper'

RSpec.describe 'Locations API', type: :request do
  let!(:locations)  { create_list(:location, 10) }
  let(:location_id) { locations.first.id }

  describe 'GET /locations' do
    before(:each) { get '/locations' }

    it 'returns locations' do
      expect(parsed_json).not_to be_empty
      expect(parsed_json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /locations/:id' do
    before { get "/locations/#{location_id}" }

    context 'when the record exists' do
      it 'returns the location' do
        expect(parsed_json).not_to be_empty
        expect(parsed_json['id']).to eq(location_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:location_id) { -1 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Location/)
      end
    end
  end

  describe 'POST /locations' do
    let(:valid_attributes) { { name: 'Ecuador' } }

    context 'when the request is valid' do
      before { post '/locations', params: valid_attributes }

      it 'creates a location' do
        expect(parsed_json['name']).to eq('Ecuador')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/locations', params: { title: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'PUT /locations/:id' do
    let(:valid_attributes) { { title: 'Shopping' } }

    context 'when the record exists' do
      before { put "/locations/#{location_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /locations/:id' do
    before { delete "/locations/#{location_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
