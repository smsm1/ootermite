require File.dirname(__FILE__) + '/../test_helper'
require 'data_controller'

# Re-raise errors caught by the controller.
class DataController; def rescue_action(e) raise e end; end

class DataControllerTest < Test::Unit::TestCase
  def setup
    @controller = DataController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_bad_methods
    get :new
    assert_response :method_not_allowed
    get :show
    assert_response :method_not_allowed
    put :edit
    assert_response :method_not_allowed
    put :update
    assert_response :method_not_allowed
    delete :destroy
    assert_response :method_not_allowed
  end

  def test_sub_hashes
    post :create, :data => {}
    assert_response :ok
    assert_tag :tag => 'error', :content => "build cannot be null"
    assert_tag :tag => 'error', :content => "data_item cannot be null"
  end

  def test_create_correct_parts
    post :create, :data => {
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
    build= Build.find_by_builder('builder1')
    assert build
    data_item= DataItem.find_by_data_type('type1')
    assert data_item
    assert_equal build.id, data_item.build_id
    
    post :create, :data => {
      :build => {
        :pws => 'pws1',
        :cws => 'cws1',
        :builder => 'builder1',
        :host => 'host1',
        :build_number => 1},
      :data_item => {
        :data_type => 'type2',
        :data => { 'value' => 1 }
      }}
    assert_response :created
    assert_equal 2, build.data_items.count
  end

end
