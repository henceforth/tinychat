class Post < ActiveRecord::Base
  attr_accessible :message, :room_id, :user_id
  validates :message, :presence => true
  validates :message, :length => { :maximum => 1000}
  validates :room_id, :presence => true
  validates :user_id, :presence => true
  belongs_to :user
  belongs_to :room
end
