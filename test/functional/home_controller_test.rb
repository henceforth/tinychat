require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  fixtures :users
  test "should get index" do
    get :index
    assert_response :success

    get :index, {}, {:user_id => 1}
    assert_redirected_to :controller => "room", :action => "overview"
  end

  test "should get login" do
    user = users(:exists).name
    pass = users(:exists).password
    post :login, {'username' => user, 'password' => pass}
    assert_redirected_to :controller => "room", :action => "overview"
  end

  test "should register user" do
    user = "new"
    pass = "pass"
    post :login, {'username' => user, 'password' => pass}
    assert_equal nil, flash[:error]
    assert_redirected_to :controller => "room", :action => "overview"
    assert_equal "User created", flash[:notice]
  end

  test "should get login and fail" do
    user = users(:wrong_pass).name
    pass = users(:wrong_pass).password
    post :login, {'username' => user, 'password' => pass}
    assert_response 500
    assert_equal "wrong username or password", flash[:error]

    post :login, {'username' => '', 'password' => ''}
    assert_response 500
  end

  test "should get logout" do
    get :logout, {}, nil 
    assert_response 302
  end

end
