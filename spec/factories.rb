require 'factory_girl'

FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@tqs.com"
  end

  sequence :name do |n|
    "name#{n}"
  end

  #factory :user do 
  #   name { generate :name }
  #   email { generate :email }
  #   password 'please'
  #end



  # factory :task do 
  #   taskable { FactoryGirl.build(:erg) }
  #   actor { FactoryGirl.build(:user) }
  #   action 'An Action'
  # end

  # factory :comment do
  #  commentable { FactoryGirl.build :erg }
  #  commentor { FactoryGirl.build(:user) }
  #  statement "A Statement"
  # end
end