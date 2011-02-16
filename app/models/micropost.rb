class Micropost < ActiveRecord::Base
  attr_accessible :content # izvana se vidi samo content
  
  belongs_to :user

  # validacije duljine i pisutnosti contenta i userid-a
  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true 

  default_scope :order => 'microposts.created_at DESC' # poredaj descending, od najnovijeg ka najstarijem

end
