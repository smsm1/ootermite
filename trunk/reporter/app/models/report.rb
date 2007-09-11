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
  def selectors
    @selectors ||= self.class.unmarshal(read_attribute(@@data_column_name)) || {}
  end
  
  # Has the session been loaded yet?
  def loaded?
    !! @selectors
  end

  private  
  def marshal_data!
    return false if !loaded?
    write_attribute(@@data_column_name, self.class.marshal(self.selectors))
  end
end
