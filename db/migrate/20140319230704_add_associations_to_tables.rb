class AddAssociationsToTables < ActiveRecord::Migration
  def change
    change_table :tasks do |t|
      t.integer :master_id
    end
  end
end
