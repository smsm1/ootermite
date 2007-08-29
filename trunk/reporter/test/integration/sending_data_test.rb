require "#{File.dirname(__FILE__)}/../test_helper"

class SendingDataTest < ActionController::IntegrationTest
  # fixtures :your, :models

  def test_simple_scalar
    post  '/data.xml', :data => {
      :build => {
        :pws => 'pws1',
        :cws => 'cws1',
        :builder => 'builder1',
        :host => 'host1',
        :build_number => 1},
      :data_item => {
        :data_type => 'type1',
        :data => { 'value' => 1 }
      }}
    assert_response :created
  end

  def test_nested_hash
    post '/data.xml', :data => {
      :build => {
        :pws => 'SRC680_m176',
        :cws => 'dbbe',
        :builder => 'edgy-jdk',
        :host => 'breon1',
        :build_number => 101 },
      :data_item => {      
        :data_type => 'oprofile',
        :data => { 'symbol' => ['symbol_0', 'symbol_1'],
          :percent => [ 10, 20 ] }
      }
    }
    assert_response :created    
  end
end
