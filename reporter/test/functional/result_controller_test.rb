require File.dirname(__FILE__) + '/../test_helper'
require 'result_controller_controller'

# Re-raise errors caught by the controller.
class ResultControllerController; def rescue_action(e) raise e end; end

class ResultControllerControllerTest < Test::Unit::TestCase
  def setup
    @controller = ResultControllerController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_create_good_record
    post :create, :result => {
      :cws => 'dbbe',
      :builder => 'edgy-jdk',
      :host => 'breon1',
      :build_number => '99',
      :data_type => 'tree_size',
      :data => { 'megabytes' => 300}.to_yaml
    }
    assert_response :created
  end

  def test_create_bad_record
    #no data
    post :create, :result => {
      :cws => 'dbbe',
      :builder => 'edgy-jdk',
      :host => 'breon1',
      :build_number => '99',
      :data_type => 'tree_size',
    }
    assert_response :ok
    # should test for errors here, actually
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
end
