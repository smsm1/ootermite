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

end
