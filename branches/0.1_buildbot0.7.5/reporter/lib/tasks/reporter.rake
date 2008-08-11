namespace :sample do
  desc "create some sample reports"
  task(:report) do
    load 'config/environment.rb'
    r= Report.new(:title => "CWS vs Milestone Tree Size", :graph_type => "Bar")

    s1= Selector.new
    s1.label= :cws
    s1.key= 'megabytes'
    s1.conditions[:order]= {:created_at => :desc}
    s1.conditions[:limit]= 1
    s1.conditions[:attributes][:data_type]= [:eq, 'tree_size']
    s1.dynamic_outputs[:pws]= :milestone
    s1.dynamic_inputs[:cws]= :cws
    s1.label= :cws

    s2= Selector.new
    s2.label= :cws
    s2.key= 'megabytes'
    s2.conditions[:order]= {:created_at => :desc}
    s2.conditions[:limit]= 1
    s2.conditions[:attributes][:data_type]= [:eq, 'tree_size']
    s2.dynamic_inputs[:milestone]= :cws
    s2.label= :pws
    r.selectors= [s1, s2]
    r.save!
  end	
end
