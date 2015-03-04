# Read about factories at https://github.com/thoughtbot/factory_girl
def import_design(file=nil, name=nil)
  name ||= Faker::Company.bs.split(/\s+/).each(&:capitalize).join(' ')
  file ||= File.join(Rails.root,'..','..','designs','exports','example-export.yaml')
  Newsletter::Design.import(file,name)
end

FactoryGirl.define do
  factory :design, class: Newsletter::Design do
    
  end
end

