class CreateSelectors < ActiveRecord::Migration
  def self.up
    create_table :selectors do |t|
      t.column :column_values,   :text   #serialized Array
      t.column :dynamic_columns, :text   #serialized Array
      t.column :group,           :text   #serialized Array
      t.column :order,           :text   #serialized Array
      t.column :limit,           :string #first, all, integer
      t.column :filter,          :string #average, etc
    end
  end

  def self.down
    drop_table :selectors
  end
end
