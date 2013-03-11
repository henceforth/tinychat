class User < ActiveRecord::Base
  attr_accessible :name, :password, :room_id
  validates :name, :presence => true
  validates :name, :uniqueness => true
  validates :name, :length => { :minimum => 2}
  validates :name, :length => { :maximum => 100}
  validates :password, :length => { :minimum => 2}
  validates :password, :length => { :maximum => 100}
  belongs_to :room

end
