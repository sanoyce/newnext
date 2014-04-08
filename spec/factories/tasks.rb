FactoryGirl.define do
  factory :task do
    statement "A Statement"
    next_action "Next Action"
    after(:build) do |newtask| 
      newtask.master = FactoryGirl.create(:user) 
      newtask.teammates << newtask.master
    end
  end
  
  factory :tasktree, class: Task do
    statement "Base Task"
    next_action "Base Action"
    after(:build) do |base|
      base.master = FactoryGirl.create(:user)
      base.teammates << base.master      
      base.children << FactoryGirl.create(:task, status: 'Active', teammates: [], master: base.master)      
      base.children << FactoryGirl.create(:task, status: 'Active', teammates: [], master: base.master)      
      base.children.first.children << FactoryGirl.create(:task, status: 'Cancelled', teammates: [], master: base.master)
      base.children.first.children << FactoryGirl.create(:task, status: 'Done', teammates: [], master: base.master)
    end
  end
  
end