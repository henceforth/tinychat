require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user new functionality" do
    user = User.new
    assert !user.save, "no user/pass given"

    user = User.new
    user[:name] = "username"
    assert !user.save, "no pass given"

    user = User.new
    user[:password] = "password"
    assert !user.save, "no user given"

    user = User.new
    user[:name] = "a"
    user[:password] = "b"
    assert !user.save, "user/pass too short"

    user = User.new
    user[:name] = "username"
    user[:password] = "password"
    assert user.save, "user/pass ok"

    user = User.new
    user[:name] = "username"
    user[:password] = "otherpassword"
    assert !user.save, "username duplicate"
  end
end
