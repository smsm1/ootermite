require File.dirname(__FILE__) + '/../test_helper'

class DataItemTest < Test::Unit::TestCase
  fixtures :data_items, :builds

  def test_validity_of_fixtures
    DataItem.find(:all).each do |d|
      assert d.valid?
    end
  end

  # best way to handle this?
  # perhaps with some association extension? 
  # unknown
  def test_create_association_semantics
    b= Build.new(:pws => 'pws1',
                 :cws => 'cws1',
                 :builder => 'builder1',
                 :build_number => 1,
                 :host => 'host1')
    assert b.save
    di= DataItem.new(:data_type => 'data_type1',
                     :data => { 'foo' => 'bar'})
    di.create_build(:pws => 'pws1',
                   :cws => 'cws1',
                   :builder => 'builder1',
                   :build_number => 1,
                   :host => 'host1')
    unless di.valid?
      puts di.errors.to_xml
    end
    assert di.save
  end

end
