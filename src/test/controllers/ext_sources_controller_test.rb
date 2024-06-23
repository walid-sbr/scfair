require "test_helper"

class ExtSourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ext_source = ext_sources(:one)
  end

  test "should get index" do
    get ext_sources_url
    assert_response :success
  end

  test "should get new" do
    get new_ext_source_url
    assert_response :success
  end

  test "should create ext_source" do
    assert_difference("ExtSource.count") do
      post ext_sources_url, params: { ext_source: {  } }
    end

    assert_redirected_to ext_source_url(ExtSource.last)
  end

  test "should show ext_source" do
    get ext_source_url(@ext_source)
    assert_response :success
  end

  test "should get edit" do
    get edit_ext_source_url(@ext_source)
    assert_response :success
  end

  test "should update ext_source" do
    patch ext_source_url(@ext_source), params: { ext_source: {  } }
    assert_redirected_to ext_source_url(@ext_source)
  end

  test "should destroy ext_source" do
    assert_difference("ExtSource.count", -1) do
      delete ext_source_url(@ext_source)
    end

    assert_redirected_to ext_sources_url
  end
end
