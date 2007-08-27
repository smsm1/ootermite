class Result < ActiveRecord::Base
  validates_presence_of :cws, :builder, :host, :build_number, 
                        :data_type
  serialize :data, Hash

  validates_numericality_of :build_number
  
  validates_each :data do |rec, attr, value|
    rec.errors.add("data", "is not a Hash") unless value.is_a? Hash
  end
end
