class API::V1::EventsController < ApplicationController
  protect_from_forgery with: :null_session
  helper_method :getMatchingEvents
  helper_method :getMatchingDayEvents
  helper_method :uniqueEvents

  # before_filter :restrict_access, except: [:create_token, :approve, :curate, :create, :new, :edit, :update, :mass_edit]

  respond_to :json, except: :curate

  # http_basic_authenticate_with name: Figaro.env.api_name, password: Figaro.env.api_password

  def create_token
    @apikey = APIKey.create!
    respond_with @apikey
  end

  def index
    @events = Event.all
    respond_with @events
  end

  def today
    @eventsToday = uniqueEvents(getMatchingDayEvents).reverse
    respond_with @eventsToday
  end

  def create
    @event = Event.create(event_params)
    @event.uuid = SecureRandom.uuid
    @event.source = "Self"
    @event.categoryList = ['Party']
    if @event.save
      redirect_to api_v1_curate_path
    else
      redirect_to api_v1_curate_path
    end
  end

  def create_today
    @event = Event.create(event_params)
    @event.uuid = SecureRandom.uuid
    @event.source = "Self"
    @event.categoryList = ['Party']
    @event.dayOn = Date.today()
    @event.dayEnd = Date.today() + 1
    if @event.save
      render json: @event, status: 200
    else
      render json: {}, status: 500
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      redirect_to api_v1_curate_path
    else
      redirect_to api_v1_curate_path
    end
  end

  def get_rating
    # 0, <10, <25, <50, <100, don't care
    price = params[:money]
    # close, far, explore, don't care
    distance = params[:location]
    # Music, Seasonal, Cultured, Learn, Investing (business), Sport, Geek, Outdoor, Good (ie: Feel good), Party, Watch (shows and stuff), religion, food 
    category = params[:category]
    @eventsToday = uniqueEvents(getMatchingDayEvents).reverse
    @eventsMatched = Event.get_best_matches(@eventsToday, price, distance, category)

  end

  def approve
    @events = params[:events].map{|e| Event.find(e) }
    @events.each do |e| 
      if e.approved == true
        e.approved = false
      else
        e.approved = true
      end
      e.save

      if e.approved == true
        Event.geocodeEvent(e)
      end
    end

    @eventsToday = uniqueEvents(getMatchingDayEvents + getMatchingDayEvents(Date.today + 1))

    @eventsToday = [@eventsToday.select{|e| e.approved == true}, @eventsToday.select{|e| e.approved == false}].flatten

    filter_events(true)
    
    respond_to do |format|
      format.json { }
    end
  end

  def approved
    @eventsToday = uniqueEvents(getMatchingDayEvents + getMatchingDayEvents(Date.today + 1)).select{|e| e.approved == true}

    # filter_events

    respond_with @eventsToday
  end

  def curate 
    @eventsToday = uniqueEvents(getMatchingDayEvents + getMatchingDayEvents(Date.today + 1))
    
    order_events

    @eventsToday = [@eventsToday.select{|e| e.approved == true}, @eventsToday.select{|e| e.approved == false}].flatten

    @event =  Event.new()

    # filter_events(true)

    respond_to do |format|
      format.html{}
    end

  end

  def tomorrow
    @eventsToday = uniqueEvents(getMatchingDayEvents(Date.today + 1))
    
    filter_events

    respond_with @eventsToday
  end

  def all
    @eventsToday = uniqueEvents(Event.all)
    
    filter_events

    respond_with @eventsToday
  end

  def partyEvents
    @eventsToday = uniqueEvents(getMatchingDayEvents).select{|event| event.source == "Nowmagazine" || event.source == "Club Crawlers" || event.source == "Just Shows"}

    filter_events
    
    respond_with @eventsToday
  end

  def mass_edit
    @events = params[:events][:events].keys.map{|e| Event.find(e)}

    @events.each_with_index do |e| 
      e.update_attributes(params[:events][:events][e.id.to_s].permit(:name, :price, :location, :dayOn, :dayEnd, :desc, :latitude, :longitude, :url, :image, :categoryList, :approved))
      e.edited = true
      e.save
    end

    @eventsToday = uniqueEvents(getMatchingDayEvents + getMatchingDayEvents(Date.today + 1))

    @eventsToday = [@eventsToday.select{|e| e.approved == true}, @eventsToday.select{|e| e.approved == false}].flatten

    filter_events(true)
    
    respond_to do |format|
      format.json { render 'approve' }
    end
  end

  private

    def order_events
      @eventsToday = [@eventsToday.select{|e| e.source == "Self"}, @eventsToday.select{|e| e.source == "Club Crawlers"},  @eventsToday.select{|e| e.source == 'Just Shows'}, @eventsToday.select{|e| e.source == 'Blog.to'}, @eventsToday.select{|e| e.source == 'Nowmagazine'}, @eventsToday.select{|e| e.source == 'Meetup'}].flatten
    end

    def event_params
      params.require(:event).permit(:name, :price, :location, :dayOn, :dayEnd, :desc, :latitude, :longitude, :url, :image, :categoryList, :approved)
    end

    def filter_events(default = false)
      @eventsToday = @eventsToday.select{|event| event.categoryList.include?(params[:cat])} if params[:cat]
      @eventsToday = @eventsToday[0..params[:limit].to_i] if params[:limit]
      @eventsToday = default ? @eventsToday : @eventsToday.select{|event| event.latitude != nil }
    end

    def restrict_access
      api_key = APIKey.find_by_access_token(params[:access_token])
      expired = api_key != nil && api_key.expires_on != nil && Date.today < Date.parse(api_key.expires_on)
      head :unauthorized unless api_key && expired
      session[:access_token] = params[:access_token]
    end

    # def restrict_access
    #   authenticate_or_request_with_http_token do |token, options|
    #   ApiKey.exists?(access_token: token)
    # end
end
