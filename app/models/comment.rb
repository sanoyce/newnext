class Comment < ActiveRecord::Base
  
  belongs_to :task
  belongs_to :commentor, class_name: "User"
  
  # Always have a commentor for any comment.
  validates_presence_of :commentor
  validates_presence_of :statement  
end
