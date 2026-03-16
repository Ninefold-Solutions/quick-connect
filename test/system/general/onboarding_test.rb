require "application_system_test_case"

class OnboardingTest < ApplicationSystemTestCase

  test "user can login" do
    regular = users(:regular)
    visit login_path
    fill_in "user_email", with: regular.email
    fill_in "user_password", with: "password"
    take_screenshot
    click_on "Log In"
    sleep(0.5)
    assert_current_path(dashboard_path(script_name: "/#{regular.account.id}"))
    take_screenshot
  end

  test "user can signup" do
    visit signup_path
    fill_in "user_first_name", with: "Aashish"
    fill_in "user_last_name", with: "Dhawan"
    fill_in "user_email", with: "awesome1@crownstack.com"
    fill_in "user_password", with: "Awesome@2021!"
    fill_in "user_password_confirmation", with: "Awesome@2021!"
    click_on "Sign Up"
    sleep(0.5)
    take_screenshot
    assert_selector "p.notice", text: "Signed in successfully."
  end

  test "user can not signup with invalid params" do
    visit signup_path
    within "#sign_up_form" do
      click_on "Sign Up"
    end
    assert_selector "div#error_explanation", text: "First name can't be blank"
    assert_selector "div#error_explanation", text: "Last name can't be blank"
    assert_selector "div#error_explanation", text: "Email can't be blank"
    assert_selector "div#error_explanation", text: "Password can't be blank"
    assert_selector "div#error_explanation", text: "Password is too short (minimum is 6 characters)"
    assert_selector "div#error_explanation", text: "Password confirmation can't be blank"
  end

  test "user can not signup with duplicate email" do
    visit signup_path
    fill_in "user_email", with: users(:regular).email
    within "#sign_up_form" do
      click_on "Sign Up"
    end
    assert_selector "div#error_explanation", text: "Email has already been taken"
  end

end
