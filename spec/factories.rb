FactoryGirl.define do
  factory :user do
    first_name "Brandon"
    last_name  "Hay"
    email "brandon.a.hay@gmail.com"
    password "password123"
    password_confirmation "password123"
  end
  factory :supplier, class: Spree::Supplier do
    email "brandon.a.hay@gmail.com"
    name "Brandon Hay"
    store_name "Brandon's Bagels"
  end
end