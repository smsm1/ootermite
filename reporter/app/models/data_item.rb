class DataItem < ActiveRecord::Base
  belongs_to :build
  validates_presence_of :data_type, :build_id
  serialize :data, Hash
  
  validates_each :data do |rec, attr, value|
    rec.errors.add("data", "is not a Hash") unless value.is_a? Hash
  end
end
