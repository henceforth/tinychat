require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "post new test" do
    post = Post.new
    assert !post.save, "not much given"

    post = Post.new
    post[:message] = "message"
    assert !post.save, "no rid/uid given"

    post[:room_id] = 1
    assert !post.save, "no uid given"

    post[:user_id] = 1
    assert post.save, "everything given"

    post = Post.new
    post[:room_id] = 1
    post[:user_id] = 1
    assert !post.save, "no message given"
  end
end
