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
# { :attributes => {:attr => [:eq/ne/lt,gt,like, value], :order = {:attr => asc/desc}, :limit => int, :group => attr}
#
# attributes from build and data_item are joined 
#
# FIXME: change to rdoc
class Selector
  attr_accessor :key, :label, :dynamic_inputs, :dynamic_outputs, :conditions
  
  def initialize
    @dynamic_inputs= {}
    @dynamic_outputs= {}
    @conditions= { :attributes => {} }
  end
  
  #dynamic vars is a hash of the form
  # {dynamic_variable_name => value }
  def run(dynamic_vars, &block)
    @dynamic_inputs.each_pair do |k,v|
      @conditions[:attributes][v]= [:eq, dynamic_vars[k]]
    end
    query= conditions_to_query
    find_options= []
    find_options << ":limit => #{@conditions[:limit]}" if @conditions[:limit]
    if @conditions[:order]
      order= []
      @conditions[:order].each_pair do |k, v|
        attr= join_mangle(k, '', 'builds.') + k.to_s
        order << "#{attr} #{v.to_s}"
      end
      find_options << ":order => '#{order.join(', ')}'"
    end
    find_options << ":group => '#{@conditions[:group].to_s}'" if @conditions[:group]
    found_records= eval("query.find(#{find_options.join(', ')})")
    found_items= found_records.collect{|r| Selector.infer_type(r.data[@key])}
    unless found_records.empty?
      @dynamic_outputs.each_pair do |k,v|
        block.call(v, eval(join_mangle(k, 'found_records[0]') + '[k]'))
      end
    end
    if dynamic_vars[@label]
      @label= dynamic_vars[@label]
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
    @conditions[:attributes].each_pair do |k,v|
      target= join_mangle(k, 'query')
      eval("#{target}.#{v[0].to_s}('#{k.to_s}', '#{v[1]}')")
    end
    query
  end
  
  # takes the "flat" naming of attributes
  # and mangles them to account for join
  # if the attribute is from DataItem, then
  #  prefix is returned
  # if the attribute is from Build, then 
  #  prefix + build_suffix is returned
  # else is an exception
  #
  # FIXME: create custom exception
  def join_mangle(attr, prefix, build_suffix='.build')
    if Build.columns_hash[attr.to_s]
      return prefix + build_suffix
    elsif DataItem.columns_hash[attr.to_s]
      return prefix
    else
      raise "#{attr.to_sym} is not a column!"
    end
  end

  def self.infer_type(input)
    if input.to_f == input.to_i
      return input.to_i
    end
    return input.to_f
  end
end
