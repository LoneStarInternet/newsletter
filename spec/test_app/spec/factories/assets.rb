FactoryGirl.define do
  factory :asset, class: Newsletter::Asset do
    #association :field
    #association :piece
    image File.open(File.join(Rails.root, 
      '/spec/support/files/iReach_logo.gif'))
  end
end
