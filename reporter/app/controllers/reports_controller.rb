class ReportsController < ApplicationController

  # GET reports_url
  def index
    # return all reports
  end

  # GET new_report_url
  def new
    # return an HTML form for describing a new report
  end

  # POST reports_url
  def create
    # create a new report
  end

  # GET report_url(:id => 1)
  # FIXME: extract dynamic vars from url
  def show
    @report= Report.find(params[:id])
#    g = eval("Gruff::#{@report.graph_type.to_s.capitalize}.new(400)")
    g= Gruff::Bar.new
    g.title = @report.title
#    g.labels = { 0 => 'Mon', 2 => 'Wed', 4 => 'Fri', 6 => 'Sun' }
    dynamic_variables= {}
    @report.selectors.each do |s|
      g.data(s.label, s.run!(dynamic_variables))
    end
    send_data(g.to_blob, 
              :disposition => 'inline', 
              :type => 'image/png', 
              :filename => "#{@report.title}.png")
  end

  # GET edit_report_url(:id => 1)
  def edit
    # return an HTML form for editing a specific report
  end

  # PUT report_url(:id => 1)
  def update
    # find and update a specific report
  end

  # DELETE report_url(:id => 1)
  def destroy
    # delete a specific report
  end
end
