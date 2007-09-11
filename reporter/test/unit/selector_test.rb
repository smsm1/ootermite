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
    s.dynamic_outputs[:foo]= :pws
    s.conditions[:attributes][:data_type]= [:eq, 'tree_size']
    s.conditions[:attributes][:pws]= [:eq, 'SRC680']
    s.key= 'megabytes'
    outputs= {}
    results= s.run({}) {|k,v| outputs[k]= v }
    assert_equal 'SRC680', outputs[:foo]
  end

  def test_run!
    s= Selector.new
    s.dynamic_outputs[:foo]= :pws
    s.conditions[:attributes][:data_type]= [:eq, 'tree_size']
    s.conditions[:attributes][:pws]= [:eq, 'SRC680']
    s.key= 'megabytes'
    dynamic_variables= {}
    s.run! dynamic_variables
    assert_equal 'SRC680', dynamic_variables[:foo]
  end

end
