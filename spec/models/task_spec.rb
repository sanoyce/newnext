require 'spec_helper'

describe Task do
  describe 'Commentable behavior' do
    before do
      @task = FactoryGirl.create :task
    end
    
    it "should add a comment" do
      @task.add_comment('label', 'A statement', @task.master)
      @task.comments.length.should eql 1
    end
  end
  
  describe 'Stateful behavior' do
    before do
      @task = FactoryGirl.create :task
      @tasktree = FactoryGirl.create :tasktree
    end

    it "should have proper status field" do
      @task.should respond_to :status
      @task.status.should eql "Active"
    end

    it "should provide STATUSES as hash" do
      Task::STATUSES.should be_instance_of Hash
    end
    
    it 'should have a set of available states' do
      @task.allowed_statuses.length.should == 4
    end
    
    it "should be invalid with bad status" do
      @task.status = 'Bad Status'
      @task.valid?.should eql false
    end

    it "Should allow all statuses by default" do
      @task.allowed_statuses.length.should eql Task::STATUSES.length
    end

    it "should provide a status_sort helper" do
      @task.status = 'Active'
      @task.status_sort.should eql 1
      @task.status = 'Done'
      @task.status_sort.should eql 3
    end

    it 'should provide _status_at for each status' do
      @task.should respond_to :done_at
    end

    it 'should not set done_at when status someday' do
      @task.status = 'Someday'
      @task.set_status_ats
      @task.done_at.should eql nil
    end
    
    it 'should set done_at when set status done' do
      @task.status = 'Done'
      @task.set_status_ats
      @task.done_at.should be_instance_of ActiveSupport::TimeWithZone
    end
    
    it 'should not set done_at when status done but already set' do
      dt = DateTime.now-1.day
      @task.done_at = dt
      @task.status = 'Done'
      @task.set_status_ats
      @task.done_at.should eql dt
    end
     
    it 'should set someday_at when set status someday' do
      @task.status = 'Someday'
      @task.set_status_ats
      @task.someday_at.should be_instance_of ActiveSupport::TimeWithZone
    end
    
    it 'should reset done_at when set status someday' do
      @task.done_at = DateTime.now-1.day
      @task.status = 'Someday'
      @task.set_status_ats
      @task.done_at.should eql nil
    end  
    
    it 'should allow all status when is a leaf Task' do
      @task.allowed_statuses.length.should eql 4
    end
    
    it 'should allow all statuses when children are done or cancelled or someday' do
      @tasktree.children.first.allowed_statuses.length.should eql 4
    end
    
    it 'should only allow Active when any child is Active' do
      @tasktree.allowed_statuses.length.should eql 1
    end
  end
end
