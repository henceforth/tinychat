class RoomController < ApplicationController
  before_filter :logged_in
  before_filter :has_room_id, :only => [:event]

  def has_room_id
    if params[:type] != "join"
      if @user.room_id.nil?
        redirect_to :action => "overview"
        flash[:error] = "no room set"
        return
      end
    end
  end

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
    #if @user.room.nil?
    if @user.room_id.nil?
      render :text => "join a room first"
      return
    end

    respond_to do |format|
      @posts = @user.room.posts
      format.html 
      format.json {render :json => @user.room.posts}
    end
  end

  #post
  def create
    #receive room form, check, create
    @room = Room.new(params[:room])
    @room.user_id = @user.id
    if @room.save
      #redirect_to :action => "index"
      redirect_to "/room/event/join/#{@room.id}"
    else
      render :action => "new", :status => 500
    end
  end

  def overview
    #display all rooms as html, json
    @rooms = Room.all
  end

  def new
    #display form for room creation
    @room = Room.new
  end

  #get
  def event
    #receive join,quit,say events, post to room
    if params[:type].nil?
      redirect_to :action => "overview"
      flash[:error] = "event type missing"
    end

    type = params[:type]
    parameter = params[:params]

    if type == "join"
      if parameter.nil? or Room.find_by_id(parameter).nil?
        flash[:error] = "room not found"
        redirect_to :action => "overview"
        return
      end
      @user.room_id = parameter  
      Post.create_post_join(@user.id, @user.room.id).save
      @user.save
      redirect_to :action => "index"
    elsif type == "leave"
      Post.create_post_leave(@user.id, @user.room.id).save
      @user.room_id = nil
      @user.save
      redirect_to :action => "index"
    elsif type == "say"
      if parameter.nil? or parameter.length < 1
        head :no_content and return
      end

      post = Post.create_post_say(parameter, @user.id, @user.room.id)
      if post.save
        respond_to do |format|
          format.html {head :ok}
          format.json {render :json => true}
        end
      else
        respond_to do |format|
          format.html{ head :not_acceptable }
          format.json {render :json => false}
        end
      end
    end
  end
end
