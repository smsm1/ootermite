class Build < ActiveRecord::Base
  validates_presence_of :cws, :builder, :host, :build_number
  validates_numericality_of :build_number
  
  validates_uniqueness_of :build_number, :scope => :builder

  serialize :data, Hash

  has_many :data_items, :dependent => :destroy
end
