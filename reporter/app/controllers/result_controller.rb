class ResultController < ApplicationController

  # only create is valid
  # FIXME: we need to catch ActiveRecord::SerializationTypeMismatch
  # and do the right thing
  def create
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
