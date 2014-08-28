class Task < ActiveRecord::Base
  include Stateful
  include Commentable
  
  acts_as_tree
  
  belongs_to :master, :class_name => 'User'
  has_and_belongs_to_many :teammates, :class_name => 'User' # only at team tasks
  
  belongs_to :sponsor_task,  :class_name => 'Task' # only at team tasks
  has_many :sponsored_tasks, :class_name => 'Task', :foreign_key => 'sponsor_task_id'
  
  validates_presence_of :statement
  validates_presence_of :next_action
  validates_presence_of :master
  
  validate :teammates_at_root
  validate :sponsor_loop
  
  scope :teamtasks, -> { roots }
  scope :user_teamtasks, lambda {|user_id|
        joins(:teammates).where('tasks_users.user_id = ?', user_id)}
  scope :active, -> { where(status: 'Active')}
  scope :someday, -> { where(status: 'Someday')}
  scope :cancelled, -> { where(status: 'Cancelled')}
  scope :done, lambda {|startdate, enddate|
        where(done_at: (startdate..enddate)) }  
  
  def team
    self.root?
  end
  
  def teammates_at_root
    if self.root? && self.teammates.length == 0
      errors.add(:teammates, 'Must have at least one teammate in a Team Task')
    elsif !self.root? && self.teammates.length > 0
      errors.add(:teammates, 'Must not have any teammates in a Non-Team Task')
    end
  end
  
  def sponsor_loop(currobj = nil)
    currobj = self unless currobj
    if self.sponsored_tasks.length > 0 && currobj.sponsor_task
      if self == currobj.sponsor_task
        errors.add(:sponsor_task, 'Sponsor task loop')
      else
        sponsor_loop(currobj.sponsor_task)
      end
    end
  end
end
