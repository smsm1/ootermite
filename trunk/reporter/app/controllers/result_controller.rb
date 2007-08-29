class ResultController < ApplicationController

  # only create is valid
  def create
    #keys:
    # pws
    # cws
    # builder
    # host
    # build_number

    # data_type
    # data
#    data_item_hash= {
#;2#B      :data => params[:result][:data]
#      :data_type => params[:result][:data_type]
#    }
#    params[:result].delete :data
#    params[:result].delete :data_type
#    build= Build.find_by_builder_and_build_number(params[:result][:builder], params[:result][
#    ##
#
    @result= Result.new(params[:result])
    if @result.save
      head :created
    else
      render :xml => @result.errors.to_xml
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
