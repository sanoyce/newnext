class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :parent_id
      
      t.string :statement
      t.string :next_action
      t.string :status, default: 'Active'

      t.datetime :active_at
      t.datetime :done_at
      t.datetime :someday_at
      t.datetime :cancelled_at

      t.timestamps
    
    create_table :task_hierarchies, :id => false do |t|
      t.integer  :ancestor_id, :null => false   # ID of the parent/grandparent/great-grandparent/... tag
      t.integer  :descendant_id, :null => false # ID of the target tag
      t.integer  :generations, :null => false   # Number of generations between the ancestor and the descendant. Parent/child = 1, for example.
    end

    # For "all progeny of…" and leaf selects:
    add_index :task_hierarchies, [:ancestor_id, :descendant_id, :generations],
      :unique => true, :name => "task_anc_desc_udx"

    # For "all ancestors of…" selects,
    add_index :task_hierarchies, [:descendant_id],
      :name => "task_desc_idx"
    end
  end
end
