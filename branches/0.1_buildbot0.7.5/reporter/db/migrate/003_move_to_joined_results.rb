class MoveToJoinedResults < ActiveRecord::Migration
  def self.up
    drop_table :results
    create_table :builds do |t|
      t.column :pws,          :string
      t.column :cws,          :string
      t.column :builder,      :string
      t.column :host,         :string
      t.column :build_number, :integer
      t.column :created_at,   :datetime
    end
    create_table :data_items do |t|
      t.column :build_id,     :integer
      t.column :data_type,    :string
      t.column :data,         :text
    end
  end

  def self.down
    drop_table :builds
    drop_table :data_items
    create_table :results do |t|
      t.column :pws,          :string
      t.column :cws,          :string
      t.column :builder,      :string
      t.column :host,         :string
      t.column :build_number, :integer
      t.column :data_type,    :string
      t.column :data,         :text
      t.column :created_at,   :datetime
    end
  end
end
