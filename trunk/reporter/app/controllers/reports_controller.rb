class ReportsController < ApplicationController

  # GET reports_url
  def index
    @reports= Report.find(:all)
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @reports.to_xml }
    end
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
  def show
    @report= Report.find(params[:id])
    g = eval("Gruff::#{@report.graph_type}.new")
    g.title = @report.title
#    g.labels = { 0 => 'Mon', 2 => 'Wed', 4 => 'Fri', 6 => 'Sun' }
    dynamic_variables= {}
    params.each_pair do |k, v|
      # fixme: action, controller
      if (k != :id and k != :format) #more elegant way?
        dynamic_variables[k.to_sym]= v
      end
    end
    logger.info("dynamic_variables= #{dynamic_variables.inspect}")
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
    @report= Report.find(params[:id])
    @report.destroy

    respond_to do |format|
      format.html { redirect_to reports_url }
      format.xml  { head :ok }
    end
  end
end
