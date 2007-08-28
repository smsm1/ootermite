require "#{File.dirname(__FILE__)}/../test_helper"

class PostResultsTest < ActionController::IntegrationTest
  # fixtures :your, :models

  def test_post_simple_hash
    post '/result.xml', :result => {
      :pws => 'SRC680_m176',
      :cws => 'dbbe',
      :builder => 'edgy-jdk',
      :host => 'breon1',
      :build_number => 101,
      :data_type => 'tree_size',
      :data => { 'megabytes' => 300 }
    }
    assert_response :created
  end

  def test_post_nested_hash
    post '/result.xml', :result => {
      :pws => 'SRC680_m176',
      :cws => 'dbbe',
      :builder => 'edgy-jdk',
      :host => 'breon1',
      :build_number => 101,
      :data_type => 'oprofile',
      :data => { 'symbol' => ['symbol_0', 'symbol_1'],
        :percent => [ 10, 20 ] }
    }
    assert_response :created    
  end
end
