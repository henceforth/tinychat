require 'test_helper'

class RoomControllerTest < ActionController::TestCase
  SESSION_USER_ID = {:user_id => 1}

  test "should get index" do
    get :index
    assert_redirected_to :controller => "home", :action => "index"
    assert_equal "must be logged in", flash[:error]

    get :index, {}, {:user_id => 1}
    assert_response 200

    assert_raise (ActiveRecord::RecordNotFound) { get :index, {}, {:user_id => 999} }
  end
#
  test "should post create" do
    post :create, {}, {:user_id => 1}
    assert_response 500

    post :create, {:name => "room"}
    assert_response 500

    #post :create, {"room[name]" => "room", "room[private]" => true, "room[password]"=>""}, {:user_id=>1}
    #assert_response 302
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
  end

  test "should get event leave" do
    get :event, {:type => "leave"}, {:user_id => 1}
    assert_redirected_to :action => "index"
  end

  test "should get event say" do
    get :event, {:type => "say"}, {:user_id => 1}
    assert_response :no_content

    get :event, {:type => "say", :params => "works"}, SESSION_USER_ID
    assert_response :ok

    get :event, {:type => "say", :params => "works", :format => :json}, SESSION_USER_ID
    assert_response :ok
  end

end
