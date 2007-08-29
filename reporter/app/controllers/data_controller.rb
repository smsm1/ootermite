class DataController < ApplicationController

  # this guy takes a hash, but included in it is
  # two subhashes that match our models
  # so, params[:data] is of the form:
  # { :build => { ....},
  #   :data_item => { ....}
  # }
  #
  # FIXME: this is very messy
  def create
    errors= []
    unless params[:data][:build]
      errors << "build cannot be null"
    end
    unless params[:data][:data_item]
      errors << "data_item cannot be null"
    end
    if errors.empty?
      build_hash= params[:data][:build]
      data_item_hash= params[:data][:data_item]
      build= Build.find_by_builder_and_build_number(build_hash[:builder], 
                                                    build_hash[:build_number])
      unless build
        build= Build.new(build_hash)
        unless build.save
          errors << build.errors.full_messages
        end
      end
    end
    if errors.empty?
      data_item= DataItem.new(data_item_hash)
      data_item.build_id = build.id
      unless data_item.save
        errors << data_item.errors.full_messages
      end
    end
    if errors.empty?
      head :created
    else
      xml= ""
      builder= Builder::XmlMarkup.new(:indent => 2, :target => xml)
      builder.instruct!
      builder.errors do |e|
        errors.each {|msg| e.error(msg)}
      end        
      render :xml => xml
    end
  end
    
  def new ; no ; end
  def show ; no ; end
  def edit ; no ; end
  def update ; no ; end
  def destroy ; no ; end

  private
  def no
    head :method_not_allowed
  end
end
