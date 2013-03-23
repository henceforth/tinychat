class Room < ActiveRecord::Base
  attr_accessible :name, :password, :private, :user_id, :last_post
  validates :name, :uniqueness => true
  validates :name, :length => { :minimum => 2}
  validates :name, :length => { :maximum => 100}
  validates :password, :length => { :maximum => 20}
  validates :user_id, :presence => true
  belongs_to :user
  has_many :posts
  has_many :users
end
