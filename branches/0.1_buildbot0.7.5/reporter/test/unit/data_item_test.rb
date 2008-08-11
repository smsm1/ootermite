require File.dirname(__FILE__) + '/../test_helper'

class DataItemTest < Test::Unit::TestCase
  fixtures :data_items, :builds

  def test_validity_of_fixtures
    DataItem.find(:all).each do |d|
      assert d.valid?
    end
  end

  def test_create_with_no_build
    di= DataItem.new(:data_type => 'type1',
                     :data => {'key' => 'value'})
    assert !di.valid?
  end
end
