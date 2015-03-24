Given(/^a design named "(.*?)" exists$/) do |name|
  FactoryGirl.create(:design, name: name) 
end
