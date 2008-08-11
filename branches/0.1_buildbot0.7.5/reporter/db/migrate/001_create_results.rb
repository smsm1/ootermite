class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.column :pws,          :string # milestone for cws; null for milestone
      t.column :cws,          :string # actually could be milestone
      t.column :builder,      :string
      t.column :host,         :string
      t.column :build_number, :integer
      t.column :data_type,    :string
      t.column :data,         :text
      t.column :created_at,   :datetime
    end
  end

  def self.down
    drop_table :results
  end
end
