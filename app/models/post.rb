class Post < ActiveRecord::Base
  attr_accessible :message, :room_id, :user_id
  validates :message, :presence => true
  validates :message, :length => { :maximum => 1000}
  validates :room_id, :presence => true
  validates :user_id, :presence => true
  belongs_to :user
  belongs_to :room

  def self.create_post_say(message, user_id, room_id)
    post = Post.new
    post[:message] = message + " " #dirtiest hack ever
    post[:user_id] = user_id
    post[:room_id] = room_id
    return post
  end

  def self.create_post_join(user_id, room_id)
    post = Post.new
    post[:message] = "joined"
    post[:user_id] = user_id
    post[:room_id] = room_id
    return post
  end

  def self.create_post_leave(user_id, room_id)
    post = Post.new
    post[:message] = "left"
    post[:user_id] = user_id
    post[:room_id] = room_id
    return post
  end

end
