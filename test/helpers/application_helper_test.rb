require "test_helper"

class ApplicationHelperTest < ActiveSupport::TestCase
  include ApplicationHelper

  test "field_icon_name maps supported keys" do
    assert_equal :envelope, field_icon_name("email")
    assert_equal :phone, field_icon_name("phone")
    assert_equal :globe, field_icon_name("website")
  end

  test "field_icon_name returns nil for blank or unknown values" do
    assert_nil field_icon_name(nil)
    assert_nil field_icon_name("")
    assert_nil field_icon_name("unknown")
  end
end
