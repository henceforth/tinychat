require 'test_helper'

class RoomControllerTest < ActionController::TestCase
  SESSION_USER_ID = {:user_id => 1, :last_update => Time.new}

  test "should get index" do
    get :index
    assert_redirected_to :controller => "home", :action => "index"
    assert_equal "must be logged in", flash[:error]

    get :index, {}, {:user_id => 1}
    assert_response 200

    assert_raise (ActiveRecord::RecordNotFound) { get :index, {}, {:user_id => 999} }

    get :index, {}, {:user_id => 2}
    assert_redirected_to :action => "overview"
    assert_equal flash[:error], "join a room first"

    #get room_index_url(:format => :json), {}, SESSION_USER_ID
    get :index, {:format => "json"}, SESSION_USER_ID
    assert_response 200
    userlist = JSON.parse(@response.body)["userlist"]
    assert userlist[0]["name"] == "user"
    postlist = JSON.parse(@response.body)["postlist"]
    assert postlist[0]["message"] == "MyString"

    get :index, {:format => "json"}, {:user_id => 3, :last_update => Time.new + 2.hour}
    assert_response :ok
  end
#
  test "should post create" do
    post :create, {}, {:user_id => 1}
    assert_response 500

    post :create, {:name => "room"}
    assert_response 500

    post :create, {:room => {:name => "room", :private => false, :password => ""}}, SESSION_USER_ID    
    #assert_redirected_to :action => "/event/join/#{assigns(:room).id}"
    assert_redirected_to "/room/event/join/#{assigns(:room).id}"

  end
#
  test "should get overview" do
    get :overview, {}, {:user_id => 1}
    assert_not_equal 0, assigns(@room).count
    assert_response :success
  end
#
  test "should get new" do
    get :new, {}, {:user_id => 1}
    assert_response :success
  end
#
  test "should get event join" do
    get :event, {}, {:user_id => 1}
    assert_redirected_to :action => "overview"
    assert_equal "event type missing", flash[:error]

    get :event, {:type => "join"}, {:user_id => 1}
    assert_redirected_to :action => "overview"
    assert_equal "room not found", flash[:error]

    get :event, {:type => "join", :params => 999}, {:user_id => 1}
    assert_redirected_to :action => "overview"
    assert_equal "room not found", flash[:error]

    get :event, {:type => "join", :params => 1}, {:user_id => 1}
    assert_redirected_to :action => "index"
    assert_equal 1, assigns(@user)[:user].room_id
    assert_equal nil, flash[:error]

    get :event, {:type => "join", :params => "2:MyPass"}, SESSION_USER_ID
    assert_equal nil, flash[:error]
    assert_redirected_to :action => "index"

    get :event, {:type => "join", :params => "2:FalsePass"}, SESSION_USER_ID
    assert_equal "invalid password", flash[:error]
    assert_redirected_to :action => "overview"

  end

  test "should get event leave" do
    get :event, {:type => "leave"}, {:user_id => 1}
    assert_redirected_to :action => "overview"

    get :event, {:type => "leave", :format => "json"}, {:user_id => 1}
    assert @response.body == "true"
  end

  test "should get event say" do
    get :event, {:type => "say"}, {:user_id => 1}
    assert_response :no_content

    get :event, {:type => "say", :params => "works"}, SESSION_USER_ID
    assert_response :ok

    get :event, {:type => "say", :params => "works", :format => :json}, SESSION_USER_ID
    assert_response :ok

    get :event, {:type => "leave"}, {:user_id => 2}
    assert_redirected_to :action => "overview"
    assert flash[:error] == "no room set"

    get :event, {:type => "say", :params => "  "}, SESSION_USER_ID
    assert_response :not_acceptable

    get :event, {:type => "say", :format => "json", :params => "  "}, SESSION_USER_ID
    assert @response.body == "false"

    get :event, {:type => "say", :params => "spam"}, {:user_id => 4}
    assert_response 412  #spam protection

  end

end
