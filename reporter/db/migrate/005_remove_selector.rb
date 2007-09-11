class RemoveSelector < ActiveRecord::Migration
  def self.up
    drop_table :selectors
  end

  def self.down
    create_table :selectors do |t|
      t.column :column_values,   :text   #serialized Array
      t.column :dynamic_columns, :text   #serialized Array
      t.column :group,           :text   #serialized Array
      t.column :order,           :text   #serialized Array
      t.column :limit,           :string #first, all, integer
      t.column :filter,          :string #average, etc
    end
  end
end
