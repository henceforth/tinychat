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
      @rooms = Room.all
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
      flash[:error] = "join a room first"
      redirect_to :action => "overview"
      return
    end

    respond_to do |format|
      @posts = @user.room.posts
      format.html { 
        session[:last_update] = nil; #reset so json refresh passes
        render;
      }

      format.json {
        if !session[:last_update].nil? and session[:last_update] >= @user.room[:last_post]
          head :ok
          return
        end
        session[:last_update] = Time.new 
        #create user list
        userlist = []
        @user.room.users.each{|user|
          userlist << {:name => user.name}
        }

        #get all posts
        postlist = []
        @posts.reverse_each{|post|
          postlist<<{:username => User.find(post.user_id)[:name], :message => post[:message], :created => post[:created_at], :roomname => @user.room.name}
        }

        json = {:userlist => userlist, :postlist => postlist}
        render :json => json
      }
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
      if !@user.room_id.nil?
        #leave other room first
        Post.create_post_leave(@user.id, @user.room.id).save
      end
      #dirty hax
      tmp = parameter.split(":", 2) #room_id:password
      room = Room.find(tmp[0])
      if !room.password.empty?
        if room.password != tmp[1]
          flash[:error] = "invalid password"
          redirect_to :action => "overview"
          return
        end
      end

      @user.room_id = parameter  
      Post.create_post_join(@user.id, @user.room.id).save
      @user.save
      redirect_to :action => "index"
    elsif type == "leave"
      Post.create_post_leave(@user.id, @user.room.id).save
      @user.room_id = nil
      @user.save
      respond_to do |format|
        format.html {
          redirect_to :action => "overview"
        }
        format.json {
          render :json => true
        }
      end
    elsif type == "say"
      if parameter.nil? or parameter.length < 1
        head :no_content and return
      end

      if Time.new - @user.last_post < 3.seconds
        head :precondition_failed and return
      end

      post = Post.create_post_say(parameter, @user.id, @user.room.id)
      if post.save
        @user.last_post = Time.new
        @user.save
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
