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
    
    trait :admin do
      admin { true }
    end
  end
  
   factory :continuous_users, class: User do
   sequence(:name) { |n| "User #{n}" }
   sequence(:email) { |n| "user-#{n}@example.com" }
   password { 'password' }
   password_confirmation { 'password' }
 end
end
