FactoryBot.define do
  factory :user do
    name { "user" }
    email { "test@example.com" }
    password {"password"}
    password_confirmation { 'password' }
    
    trait :another do
      name { "another" }
      email { "another@example.com" }
    end
  end
end
