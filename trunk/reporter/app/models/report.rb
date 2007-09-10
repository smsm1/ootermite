
## dynamic_input is a hash that
# allows the stored finder to 
# have conditions from a dynamic 
# named variable.  This can
# come from either the URL or
# another selector that has been
# run.  One must be careful not
# to make circular dependencies
#
# it is of the form { dynamic_variable_name => attribute_name }
#
# dynamic_output is a hash that 
# allows the stored finder to 
# create dynamic named variables.
# These can then be used by other
# selectors in their dynamic_inputs.
# NOTE: only the first result sets
# output variables
#
# it is of the form { attribute_name => dynamic_variable_name }
class Selector
  attr_accessor :key, :label, :dynamic_input, :dynamic_output, :query
  
  def initialize
    @query= Build.query
    @dynamic_input= {}
    @dynamic_output= {}
  end
  
  #dynamic vars is a hash of the form
  # {dynamic_variable_name => value }
  def run(dynamic_vars, &block)
    @dynamic_input.each_pair do |k,v|
      @query.eq(v, dynamic_vars[k])
    end
    found_records= @query.find
    found_items= found_records.collect{|r| r.data_item.data[@key]}
    @dynamic_output.each_pair do |k,v|      
      block.call(v, found_records[0][k])
    end
    found_items
  end
  
  def run!(dynamic_vars, target_hash)
    run(dynamic_vars) {|k,v| target_hash[k]= v}
  end
end

class Report < ActiveRecord::Base
  validates_uniqueness_of :title
  validates_presence_of :title, :graph_type
  validates_inclusion_of :graph_type, :in=>[:bar, :pie, :line]


  # the following has been pinched from active_record_store.rb 
  # with slight modification
  attr_writer :selectors
  cattr_accessor :data_column_name
  self.data_column_name = 'selectors_dump'
  before_save :marshal_data!
  
  class << self
    # Don't try to reload ARStore::Session in dev mode.
    def reloadable? #:nodoc:
      false
    end
    
    def data_column_size_limit
      @data_column_size_limit ||= columns_hash[@@data_column_name].limit
    end
    
    def marshal(data)   Base64.encode64(Marshal.dump(data)) if data end
    def unmarshal(data) Marshal.load(Base64.decode64(data)) if data end
  end

  # Lazy-unmarshal session state.
  def data
    @selectors ||= self.class.unmarshal(read_attribute(@@data_column_name)) || {}
  end
  
  # Has the session been loaded yet?
  def loaded?
    !! @selectors
  end

  private  
  def marshal_data!
    return false if !loaded?
    write_attribute(@@data_column_name, self.class.marshal(self.data))
  end
end
