class HomeController < ApplicationController
  def index
    #display user login
  end

  def login
    #check if user in db, else create
    if User.where(:name => params[:username]).exists?
      #check password
      user = User.where(:name => params[:username]).first
      if user[:password] != params[:password]
        flash[:error] = "wrong username or password"
        render :action => "index", :status => 500
        return
      end
    else
      #register user
      user = User.new
      user[:name] = params[:username]
      user[:password] = params[:password]
      if user.save
        flash[:notice] = "User created"
      else
        flash[:error] = user.errors.messages
        render :action => "index", :status => 500
        return
      end 
    end
    session[:user_id] = user.id
    redirect_to :controller => "room", :action => "overview"
  end

  def logout
    #destroy user session
    reset_session
  end
end
