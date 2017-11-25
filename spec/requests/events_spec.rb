require 'rails_helper'

RSpec.describe 'Events API', type: :request do
  let!(:events)  { create_list(:event, 10) }
  let(:event_id) { events.first.id }

  describe 'GET /events' do
    before(:each) { get '/events' }

    it 'returns events' do
      expect(parsed_json).not_to be_empty
      expect(parsed_json.size).to eq(10)
    end

    it 'excludes items marked as deleted on the DB' do
      expect(parsed_json.size).to eq(10)
      Event.find(event_id).remove!

      get '/events'

      expect(parsed_json.size).to eq(9)
      expect(parsed_json.map { |e| e['id'] }).not_to include(event_id)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /events/:id' do
    before { get "/events/#{event_id}" }

    context 'when the record exists' do
      it 'returns the event' do
        expect(parsed_json).not_to be_empty
        expect(parsed_json['id']).to eq(event_id)
      end

      it 'returns the event with the inferred duration' do
        expect(parsed_json['duration']).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:event_id) { -1 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Event/)
      end
    end
  end

  describe 'POST /events' do
    let(:valid_attributes) {
      { name: 'My new Event', location_id: location.id, user_id: user.id }
    }
    let(:user)             { create(:user) }
    let(:location)         { create(:location) }

    context 'when the request is valid' do
      before { post '/events', params: valid_attributes }

      it 'creates a event' do
        expect(parsed_json['name']).to eq('My new Event')
        expect(parsed_json['state']).to eq('draft')
      end

      it 'creates an event with the given location id' do
        event = Event.find(parsed_json['id'])
        expect(event.location.id).to eq(location.id)
      end

      it 'creates an event with the given user id' do
        event = Event.find(parsed_json['id'])
        expect(event.user.id).to eq(user.id)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an event is created in a published state' do
      it 'creates a published event' do
        complete_attributes = valid_attributes.merge(
          start_date: '2017-10-22', end_date: '2017-11-22',
          description: 'Long formatted description', state: 'published'
        )
        post '/events', params: complete_attributes

        expect(parsed_json['name']).to eq('My new Event')
        expect(parsed_json['state']).to eq('published')
      end

      it 'creates a published event using duration param' do
        complete_attributes = valid_attributes.merge(
          duration: '5', start_date: '2017-10-22',
          description: 'Long formatted description', state: 'published'
        )
        post '/events', params: complete_attributes

        expect(parsed_json['end_date']).to eq('2017-10-27')
        expect(parsed_json['state']).to eq('published')
      end

      context 'when the request is invalid' do
        before { post '/events', params: valid_attributes.merge(state: 'published') }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/Validation failed:/)
        end
      end
    end
  end

  describe 'POST /events/:id/publish' do
    context 'when the event is ready to publish' do
      let!(:draft) { create(:event, state: 'draft') }

      before { post "/events/#{draft.id}/publish" }

      it 'publishes a valid event' do
        expect(parsed_json['state']).to eq('published')
      end
    end
  end

  describe 'POST /events/:id/unpublish' do
    context 'when the event is already published' do
      let!(:published) { create(:event, state: 'published') }

      before { post "/events/#{published.id}/unpublish" }

      it 'unpublishes a published event' do
        expect(parsed_json['state']).to eq('draft')
      end
    end
  end

  describe 'PUT /events/:id' do
    let(:valid_attributes) { { end_date: '2017-10-21', state: 'published' } }

    context 'when the record exists' do
      before { put "/events/#{event_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /events/:id' do
    before { delete "/events/#{event_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'marks the event as deleted' do
      event = Event.find(event_id)
      expect(event).to be_deleted
    end
  end
end
