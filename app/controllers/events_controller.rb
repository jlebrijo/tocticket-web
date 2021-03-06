class EventsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :to_uri]
  before_filter :is_event_organizer, :only => [:edit, :update, :destroy]
  
  # GET /events
  def index
    @events = Event.where("organizer_id=?",current_user.id)
  end

  # GET /events/1
  def show
    @event = Event.find(params[:id])
  end

  # GET /to/:uri
  def to_uri
    @event = Event.find_by_uri(params[:uri])
    if @event.nil?
      render :file => 'public/404.html'
    else
      render :show
    end
  end

  # GET /events/new
  def new
    @event = Event.new
    @event.ticket_types[0] = TicketType.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = Event.new(params[:event])
    @event.organizer = current_user
    @event.paypal_account = current_user.email
    @event.set_default_custom_uri

    unless @event.save
      render action: "new"
    end
  end

  # PUT /events/1
  def update
      if @event.update_attributes(params[:event])
        redirect_to @event, notice: t('events.message.success_update')
      else
        render action: "edit"
      end
  end

  # DELETE /events/1
  def destroy
    @event.destroy

    redirect_to events_url
  end
  
  private
  def is_event_organizer
    @event = Event.find(params[:id])
    unless current_user == @event.organizer
      redirect_to @event, alert: t('events.message.no_authorize')
    end
  end
end
