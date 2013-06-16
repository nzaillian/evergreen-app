FactoryGirl.define do
  factory :question do
    title { generate(:company_name) }    
    body "Some body text"
    user
    company
  end
end