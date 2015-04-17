Then(/^a newsletter named "(.*?)" should exist$/) do |name|
  @newsletter = Newsletter::Newsletter.where(name: name).first
  expect(@newsletter).not_to be nil
end

Then(/^that newsletter should have the design named "(.*?)"$/) do |name|
  expect(@newsletter.design.name).to eq name
end

Given(/^a newsletter named "(.*?)" exists$/) do |name|
  design = import_design
  FactoryGirl.create(:newsletter, name: name, design: design) 
end

Given(/^a newsletter named "(.*?)" exists with design named "(.*?)"$/) do |news_name, design_name|
  design = Newsletter::Design.where(name: design_name).first
  FactoryGirl.create(:newsletter, name: news_name, design: design)
end

Given(/^(\d+) newsletters exist$/) do |count|
  design = import_design(nil,Faker::Company.bs)
  count.to_i.times{FactoryGirl.create(:newsletter, design: design)}
end

