FactoryGirl.define do
  sequence :company_name do |n|
    "Company #{SecureRandom.hex(3)}"
  end

  sequence :company_slug do |n|
    "company-#{SecureRandom.hex(3)}"
  end

  factory :company do
    name { generate(:company_name) }    
    slug { generate(:company_slug) }
  end
end