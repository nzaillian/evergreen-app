FactoryGirl.define do
  sequence :username do |n|
    "user#{n}"
  end

  sequence :email do |n|
    "email#{n}@example.com"
  end

  sequence :last_name do |n|
    "Demo#{n}@example.com"
  end  

  sequence :nickname do |n|
    "User #{n}"
  end


  # generates postgres-compatible UUIDs
  sequence :uuid do |n|
    vals = []

    vals <<  SecureRandom.hex(5).slice(0,8)

    (0..2).each do
      vals << SecureRandom.hex(3).slice(0, 4)
    end

    vals << SecureRandom.hex(6).slice(0,12)


    vals.join("-")
  end
end