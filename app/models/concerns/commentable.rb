module Commentable
  extend ActiveSupport::Concern
  included do
    has_many :comments
  end
  
  def add_comment(label, statement, commentor)
    comment = Comment.new
    comment.label = label
    comment.statement = statement
    comment.commentor = commentor
    self.comments << comment
    return comment
  end
end