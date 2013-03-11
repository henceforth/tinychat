require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get login" do
    post :login, {'username' => 'user', 'password' => 'pass'}
    assert_response 302

    post :login, {'username' => 'user', 'password' => 'pas'}
    assert_response 500

    post :login, {'username' => '', 'password' => 'pas'}
    assert_response 500
  end

  test "should get logout" do
    get :logout, {}, nil 
    #should actually fail, no session given
    assert_response :success
  end

end
