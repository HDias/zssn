FactoryBot.define do
  factory :trade do
    association :barterer, factory: :survivor
    association :counterpart, factory: :survivor
  end
end
