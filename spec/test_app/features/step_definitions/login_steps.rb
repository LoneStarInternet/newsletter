Given(/^I am logged in and authorized for everything$/) do
  @user = FactoryGirl.create(:user, last_name: "the_admin")
end

