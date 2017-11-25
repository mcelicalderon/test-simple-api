class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy, :publish, :unpublish]

  def index
    @events = Event.all
    json_response(@events)
  end

  def create
    @event = Event.create!(event_params)
    json_response(@event, :created)
  end

  def show
    json_response(@event)
  end

  def update
    @event.update!(event_params)
    head :no_content
  end

  def destroy
    @event.destroy
    head :no_content
  end

  def publish
    @event.publish!
    json_response(@event)
  end

  def unpublish
    @event.unpublish!
    json_response(@event)
  end

  private

  def event_params
    params.permit(
      :start_date, :end_date, :name, :description,
      :user_id, :location_id, :state, :duration
    )
  end

  def set_event
    @event = Event.find(params[:id] || params[:event_id])
  end
end
