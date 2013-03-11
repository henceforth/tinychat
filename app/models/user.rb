class User < ActiveRecord::Base
  attr_accessible :name, :password, :room_id
end
