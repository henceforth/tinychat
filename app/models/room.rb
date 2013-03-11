class Room < ActiveRecord::Base
  attr_accessible :name, :password, :private, :user_id
end
