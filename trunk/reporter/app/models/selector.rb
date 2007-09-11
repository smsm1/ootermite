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
#
#
# conditions is a hash of the form
# { attribute_name => value }
# that is used to build a query.  The condition is
# that the attribute must be equal to the value
# it normalizes the attribute names, to obscure the
# build/data_item join
#
# FIXME: change to rdoc
class Selector
  attr_accessor :key, :label, :dynamic_inputs, :dynamic_outputs, :conditions
  
  def initialize
    @dynamic_inputs= {}
    @dynamic_outputs= {}
    @conditions= {}
  end
  
  #dynamic vars is a hash of the form
  # {dynamic_variable_name => value }
  #
  # FIXME: this ought to be more DRY
  def run(dynamic_vars, &block)
    @dynamic_inputs.each_pair do |k,v|
      @conditions[v]= dynamic_vars[k]
    end
    query= conditions_to_query
    found_records= query.find
    found_items= found_records.collect{|r| r.data[@key]}
    @dynamic_outputs.each_pair do |k,v|
      if HashWithIndifferentAccess.new(Build.columns_hash)[v]
        block.call(k, found_records[0].build[v])
      elsif HashWithIndifferentAccess.new(DataItem.columns_hash)[v]
        block.call(k, found_records[0][v])
      else
        raise "#{v} is not a column!"
      end
    end
    found_items
  end
  
  def run!(dynamic_vars)
    run(dynamic_vars) {|k,v| dynamic_vars[k]= v}
  end
 
  private 
  def conditions_to_query
    query= DataItem.query
    query.join :build
    @conditions.each_pair do |k,v|
      target= nil
      if HashWithIndifferentAccess.new(Build.columns_hash)[k]
        target= query.build
      elsif HashWithIndifferentAccess.new(DataItem.columns_hash)[k]
        target= query
      else
        raise "#{k} is not a column!"
      end
      target.eq(k, v)
    end
    query
  end
  
end
