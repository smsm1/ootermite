require File.dirname(__FILE__) + '/../test_helper'

class SelectorTest < Test::Unit::TestCase
  fixtures :builds, :data_items


  def test_new
    s= Selector.new
    assert_kind_of Hash, s.dynamic_inputs
    assert_kind_of Hash, s.dynamic_outputs
    assert_kind_of Hash, s.conditions
  end

  # really a test of cirteriaQuery
  def test_simple_query
    cq= DataItem.query
    cq.join :build
    cq.eq(:data_type, 'tree_size')
    assert_equal cq.find, DataItem.find_all_by_data_type('tree_size')
  end

  def test_associated_query
    cq= DataItem.query
    cq.join :build
    cq.build.eq(:pws, 'SRC680')
    cq.eq(:data_type, 'tree_size')

    data_items= DataItem.find_all_by_data_type('tree_size')
    data_items.collect! do |di| 
      if di.build.pws == 'SRC680'
        di
      else
        nil
      end
    end
    data_items.compact!
    assert_equal data_items.length, cq.find.length
  end

  def test_run_with_inputs
    inputs= { :foo => 'SRC680' }
    s= Selector.new
    s.dynamic_inputs[:foo]= :pws
    s.conditions[:attributes][:data_type]= [:eq, 'tree_size']
    s.key= 'megabytes'
    results= s.run(inputs) {|k,v| nil }

    dq= DataItem.query
    dq.join :build
    dq.build.eq(:pws, 'SRC680')
    dq.eq(:data_type, 'tree_size')
    correct_answer= dq.find.collect{|di| di.data['megabytes'] } 
    assert_equal correct_answer, results    
  end

  def test_run_with_outputs
    s= Selector.new
    s.dynamic_outputs[:pws]= :foo
    s.conditions[:attributes][:data_type]= [:eq, 'tree_size']
    s.conditions[:attributes][:pws]= [:eq, 'SRC680']
    s.key= 'megabytes'
    outputs= {}
    results= s.run({}) {|k,v| outputs[k]= v }
    assert_equal 'SRC680', outputs[:foo]
  end

  def test_run!
    s= Selector.new
    s.dynamic_outputs[:pws]= :foo
    s.conditions[:attributes][:data_type]= [:eq, 'tree_size']
    s.conditions[:attributes][:pws]= [:eq, 'SRC680']
    s.key= 'megabytes'
    dynamic_variables= {}
    s.run! dynamic_variables
    assert_equal 'SRC680', dynamic_variables[:foo]
  end

  def test_run_with_limits
    s= Selector.new
    s.conditions[:attributes][:data_type]= [:eq, 'tree_size']
    s.conditions[:limit]= 1
    s.key= 'megabytes'
    results= s.run!({})
    assert_equal 1, results.length
  end
  
  def test_run_with_order
    s= Selector.new
    s.conditions[:attributes][:pws]= [:eq, 'SRC680']
    s.conditions[:attributes][:data_type]= [:eq, 'tree_size']
    s.key= 'megabytes'
    s.conditions[:order]= {:created_at => :desc}
    results= s.run!({})

    dq= DataItem.query
    dq.join :build
    dq.build.eq(:pws, 'SRC680')
    dq.eq(:data_type, 'tree_size')
    correct_answer= dq.find(:order => "builds.created_at DESC").collect{|r| r.data['megabytes']}
    assert_equal correct_answer, results    
  end

  def test_run_with_group
    s= Selector.new
    s.conditions[:attributes][:pws]= [:eq, 'SRC680']
    s.conditions[:attributes][:data_type]= [:eq, 'tree_size']
    s.key= 'megabytes'
    s.conditions[:group]= :builder
    results= s.run!({})
    
    dq= DataItem.query
    dq.join :build
    dq.build.eq(:pws, 'SRC680')
    dq.eq(:data_type, 'tree_size')
    correct_answer= dq.find(:group => :builder).collect{|r| r.data['megabytes']}
    assert_equal correct_answer, results        
  end

  def test_input_and_output
    dynamic_variables= {:bar => 'SRC680_m18'}
    s1= Selector.new
    s1.label= :s1
    s1.key= 'megabytes'
    s1.conditions[:attributes][:data_type]= [:eq, 'tree_size']
    s1.dynamic_outputs[:cws]= :foo
    s1.dynamic_inputs[:bar]= :cws
    s1.run!(dynamic_variables)
    assert_equal "SRC680_m18", dynamic_variables[:bar]    
  end

  #fail! fail! fail!  WTF?!?!
  def test_sample_report
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
    dynamic_variables= {:cws => 'cws_0'}
    outputs= {}
    s1_result= s1.run!(dynamic_variables)
    assert dynamic_variables[:milestone]
    s2_result= s2.run!(dynamic_variables)
    assert_equal 1, s1_result.length
    assert_equal s1_result.length, s2_result.length
  end
end
