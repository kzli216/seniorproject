require 'test_helper'

class PhasesControllersControllerTest < ActionController::TestCase
  setup do
    @phases_controller = phases_controllers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:phases_controllers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create phases_controller" do
    assert_difference('PhasesController.count') do
      post :create, phases_controller: {  }
    end

    assert_redirected_to phases_controller_path(assigns(:phases_controller))
  end

  test "should show phases_controller" do
    get :show, id: @phases_controller
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @phases_controller
    assert_response :success
  end

  test "should update phases_controller" do
    patch :update, id: @phases_controller, phases_controller: {  }
    assert_redirected_to phases_controller_path(assigns(:phases_controller))
  end

  test "should destroy phases_controller" do
    assert_difference('PhasesController.count', -1) do
      delete :destroy, id: @phases_controller
    end

    assert_redirected_to phases_controllers_path
  end
end
