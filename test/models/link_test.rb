require "test_helper"

class LinkTest < ActiveSupport::TestCase
  test "link_type_label returns configured label for key" do
    link = links(:one)

    assert_equal "LinkedIn", link.link_type_label
  end

  test "link_type_label falls back for unknown key" do
    link = links(:one)
    link.link_type = "custom"

    assert_equal "Custom", link.link_type_label
  end
end
