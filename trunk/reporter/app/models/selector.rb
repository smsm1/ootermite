#FIXME: add validations!!

class Selector < ActiveRecord::Base
  serialize :column_values, Array
  serialize :dynamic_columns, Array
  serialize :order, Array
  serialize :group, Array
  
  validates_presence_of :limit

  # a discussion of meanings of values of attributes follows
  #
  # @column_values:
  #   an array of pairs of columns and values
  #   to be used in a find.  Example: 
  #   [['pws', 'SRC680_m176'], ['builder', 'edgy-jdk']]
  #
  # @dynamic_columns:
  #   an array containing the column names which will be 
  #   dynamically looked up by select
  #
  # @group
  #   an array of columns to group by
  # 
  # @order
  #   a serialized array of columns and DESC of form:
  #     [[column, :DESC/nil], .... ]
  #
  # @limit
  #   a string representing a limit to the sql
  #   result set, valid values include: all, first, or an integer
  #
  # @filter
  #   a string representing the operation to be preformed
  #   on the resulting array.  valid values include: average, min,
  #   max  Note: can only be done on scalar values

  # parameters:
  # key
  #   key to use in Result#data to return a value
  # 
  # columns
  #   hash of columns used by dynamic_columns
  def select(key, columns)
    column_values= Hash.new
    self.dynamic_columns.each do |column|
      column_values[column]= columns[column]
    end
    self.column_values.each do |cv|
      column_values[cv[0]]= cv[1]
    end
    #format of find
    #Result.find(:all/:first, :conditions => { :column => value, ...}, :group => "column, column, ..., column", :limit => int}
    find= "Result.find("
    if self.limit == ":first"
      find << ":first"
    else
      find << ":all"
    end
    unless column_values.empty?
      find << ", :conditions => #{column_values.inspect}"
    end
    if self.group
      find << ", :group => #{self.group.inspect}"
    end
    if self.limit.to_i != 0
      find << ", :limit => #{self.limit.to_i}"
    end
    if self.order
      find << ", :order => "
      find << self.order.map{|e| e[1] ? e.join(" ") : e[0]}.join(", ").inspect
    end
    find << ")"
    a= Array.new
    eval(find).collect{|r| r.data[key]}
  end

end
