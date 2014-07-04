class EventsController < ApplicationController

  before_action :signed_in_user

  def day
    @events = current_user.events_at_day Date.parse params[:date]
    render 'day_success'
  end

  def month
    @date = Date.parse params[:date]
    @events = current_user.events_at_month @date
  end

  def show
    event = Event.find params[:id]
    authorize! :show, event
    render :json => { success: true, event: event, info: 'event' }
  end

  def create
    event = current_user.events.new event_params
    if event.save
      render :json => {success: true, event: event, info: 'event created'}
    else
      render :json => {success: false, errors: event.errors, info: 'event creation failed'}
    end
  end

  def update
    event = Event.find params[:id]
    authorize! :update, event
    if event.update event_params
      render :json => {success: true, event: event, info: 'event updated'}
    else
      render :json => {success: false, errors: event.errors, info: 'event updating failed'}
    end
  end

  def destroy
    event = Event.find params[:id]
    authorize! :destroy, event
    if event.destroy
      render :json => {success: true, info: 'event deleted'}
    else
      render :json => {success: false, info: 'event not deleted'}
    end
  end

  private

    def event_params
      params.require(:event).permit(:name, :period, :started_at)
    end

    def signed_in_user
      render :json => {status: 'unath'}, status: 401 unless signed_in?
    end

end
