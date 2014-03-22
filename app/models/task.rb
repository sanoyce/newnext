class Task < ActiveRecord::Base
  include Stateful
  include Commentable
  
  acts_as_tree
  
  belongs_to :master, :class_name => 'User'
  has_and_belongs_to_many :teammates, :class_name => 'User'
  
  validates_presence_of :statement
  validates_presence_of :next_action
  validates_presence_of :master
  
  validate :teammates_at_root
  
  def teammates_at_root
    if self.root? && self.teammates.length == 0
      errors.add(:teammates, 'Must have at least one teammate in a Team Task')
    elsif !self.root? && self.teammates.length > 0
      errors.add(:teammates, 'Must not have any teammates in a Non-Team Task')
    end
  end
end
