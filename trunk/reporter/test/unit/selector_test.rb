require File.dirname(__FILE__) + '/../test_helper'

class SelectorTest < Test::Unit::TestCase
  fixtures :selectors, :results

  def test_fixture_validity
    Selector.find(:all).each {|s| assert s.valid? }
  end

  def minimally_test_select
    set= selectors(:one).select('megabytes', :cws => 'dbbe')
    set2= Result.find(:all, :conditions => {'data_type' => 'tree_size', 'cws' => 'dbbe'}, :group => "builder, host", :order => 'builder DESC')
    assert_equal set2, set
  end

end
