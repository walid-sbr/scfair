require "application_system_test_case"

class ExtSourcesTest < ApplicationSystemTestCase
  setup do
    @ext_source = ext_sources(:one)
  end

  test "visiting the index" do
    visit ext_sources_url
    assert_selector "h1", text: "Ext sources"
  end

  test "should create ext source" do
    visit ext_sources_url
    click_on "New ext source"

    click_on "Create Ext source"

    assert_text "Ext source was successfully created"
    click_on "Back"
  end

  test "should update Ext source" do
    visit ext_source_url(@ext_source)
    click_on "Edit this ext source", match: :first

    click_on "Update Ext source"

    assert_text "Ext source was successfully updated"
    click_on "Back"
  end

  test "should destroy Ext source" do
    visit ext_source_url(@ext_source)
    click_on "Destroy this ext source", match: :first

    assert_text "Ext source was successfully destroyed"
  end
end
