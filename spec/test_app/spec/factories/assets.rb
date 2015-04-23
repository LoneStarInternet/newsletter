FactoryGirl.define do
  factory :asset, class: Newsletter::Asset do
    #association :field
    #association :piece
    image File.open(File.join(Newsletter::PLUGIN_ROOT,'spec','test_app',
      'spec','support','files','iReach_logo.gif'))
  end
end
