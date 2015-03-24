# Read about factories at https://github.com/thoughtbot/factory_girl
begin
  FactoryGirl.define do
    factory :user do
      first_name {Faker::Name.first_name}
      last_name {Faker::Name.last_name}
      email {Faker::Internet.email}
      phone {Faker::PhoneNumber.phone_number}
    end
  end
rescue FactoryGirl::DuplicateDefinitionError => e
  # this is OK ... since it could blow up because of ireach
end
