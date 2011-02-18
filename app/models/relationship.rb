class Relationship < ActiveRecord::Base
  attr_accessible :followed_id # kad bi follower_id bio dostupan, netko bi mogao na silu tjerati usere da ga prate

  belongs_to :follower, :class_name => "User"
  belongs_to :followed, :class_name => "User"

  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
end
