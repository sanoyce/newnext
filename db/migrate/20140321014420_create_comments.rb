class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :label
      t.string :statement
      
      t.integer :commentor_id
      t.integer :task_id
      
      t.timestamps
    end
  end
end
