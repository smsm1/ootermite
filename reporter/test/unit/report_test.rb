require File.dirname(__FILE__) + '/../test_helper'

class ReportTest < Test::Unit::TestCase
#  fixtures :reports

  def test_create
    r= Report.new
    r.selectors= []
    r.selectors << Selector.new
    r.title= "test title"
    r.graph_type= 'Bar'
    assert r.valid?
    assert r.save

    r2= Report.find(r.id)
    assert r2
    assert r2.selectors
    assert_kind_of Array, r2.selectors
    assert_kind_of Selector, r2.selectors[0]
  end

  def test_input_names
    r= Report.new
    r.selectors= []
    2.times { r.selectors << Selector.new}
    assert_equal [], r.input_names
    r.selectors[0].dynamic_inputs = { 
      :var1 => :cws,
      :var2 => :pws }
    r.selectors[1].dynamic_inputs = { 
      :var3 => :cws,
      :var4 => :pws }
    assert_equal [:var1, :var2, :var3, :var4], r.input_names
  end

end
