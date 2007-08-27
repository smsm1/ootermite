# ATTENTION! ATTENTION! ATTENTION!
# perhaps one should re-look at find and some of the options
# such as :group, :order, :limit and perhaps do some more attributes
#
# limit => scalar
# group => it seems from some experimentation that group
#          by works like distinct, in that group by builder
#          makes builder distinct
# order => array of columns/desc modifier
#
# consider the start_time selector:
# desired sql is: 'select * from results where cws = 'dbbe' and data_type = 'start_time' group by builder;'
#
# however, this select gives us start_times by builder but various
# hosts.  Thus, if we have two hosts for the same builder: fast and
# slow, the result set may include samples for either fast or slow.
#
# perhaps we should have ruby deal with it.  If we eliminated the 
# group by clause, we would have an unordered array which we'll call 
# r.  We need a list of builders as b.  Our output hash is o.
# b.each do |builder|
#   o[builder]= r.map{|result| result if result.builder == builder}.compact.map{|result| r['data']['start_time']}.average
# end
# 
# this gives us:
#   {
#     'builder1' => value1,
#     'builder2' => value2,
#     'buildern' => valuen
#   }
#
# how to encode that?
# 
#
class CreateSelectors < ActiveRecord::Migration
  def self.up
    create_table :selectors do |t|
      t.column :column_values,   :text   #serialized Array
      t.column :dynamic_columns, :text   #serialized Array
      t.column :group,           :text   #serialized Array
      t.column :order,           :text   #serialized Array
      t.column :limit,           :string #first, all, integer
      t.column :filter,          :string #average, etc
    end
  end

  def self.down
    drop_table :selectors
  end
end
