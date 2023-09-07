FactoryBot.define do
  factory :user do
    name { "user" }
    email { "test@example.com" }
    password {"password"}
    password_confirmation { 'password' }
    activated { true }
    
    trait :another do
      name { "another" }
      email { "another@example.com" }
    end
    
    trait :admin do
      admin { true }
    end
  end
    
  factory :no_activate_user, class: User do
    name { "no_activate_user" }
    email { "no_activate_user@example.com" }
    password {"password"}
    password_confirmation { 'password' }
  end
  
  factory :continuous_users, class: User do
     sequence(:name) { |n| "User #{n}" }
     sequence(:email) { |n| "user-#{n}@example.com" }
     password { 'password' }
     password_confirmation { 'password' }
     activated { true }
  end
end
