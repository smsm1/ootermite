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
    # FIXME: test the tags
  end

end
