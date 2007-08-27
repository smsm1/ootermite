require File.dirname(__FILE__) + '/../test_helper'

class ResultTest < Test::Unit::TestCase
  fixtures :results

  def test_validity_of_fixtures
    Result.find(:all).each do |r|
      assert r.valid?
    end
  end

end
