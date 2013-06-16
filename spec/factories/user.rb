FactoryGirl.define do
  factory :user do
    username { generate(:username) }
    first_name "Demo"
    last_name { generate(:last_name) }
    email { generate(:email) }
    password "password"
    password_confirmation "password"
    nickname { generate(:nickname) }
  end
end