class Post < ActiveRecord::Base
  attr_accessible :message, :room_id, :user_id
end
