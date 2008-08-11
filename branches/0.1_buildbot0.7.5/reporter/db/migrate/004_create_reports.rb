class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.column :title, :string
      t.column :graph_type, :string
      t.column :selectors_dump, :text  #marshalled selectors
    end
  end

  def self.down
    drop_table :reports
  end
end
