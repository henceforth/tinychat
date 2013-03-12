class RoomController < ApplicationController
  before_filter :logged_in

  def logged_in
    if session[:user_id].nil?
      flash[:error] = "must be logged in"
      redirect_to :controller => "home", :action => "index" 
      return
    else
      @user = User.find(session[:user_id])
    end
  end

  def index
    #display room status as html, json
  end

  #post
  def create
    #receive room form, check, create
    @room = Room.new(params[:room])
    @room.user_id = @user.id
    if @room.save
      redirect_to :action => "index"
    else
      render :action => "new", status => 500
    end
  end

  def overview
    @rooms = Room.all
    #display all rooms as html, json
  end

  def new
    @room = Room.new
    #display form for room creation
  end

  #post
  def event
    #receive join,quit,say events, post to room
  end
end
