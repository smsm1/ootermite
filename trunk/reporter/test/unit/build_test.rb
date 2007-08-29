require File.dirname(__FILE__) + '/../test_helper'

class BuildTest < Test::Unit::TestCase
  fixtures :builds

  def test_validity_of_fixtures
    Build.find(:all).each do |r|
      assert r.valid?
    end
  end
end
