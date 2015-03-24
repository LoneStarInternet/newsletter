Then(/^a newsletter named "(.*?)" should exist$/) do |name|
  @newsletter = Newsletter::Newsletter.where(name: name).first
  expect(@newsletter).not_to be nil
end

Then(/^that newsletter should have the design named "(.*?)"$/) do |name|
  expect(@newsletter.design.name).to eq name
end

