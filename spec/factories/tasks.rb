# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Task #{n}" }
    project

    trait :full do
      done { false }
      priority { 1 }
      deadline { 1.day.after }
    end
  end
end
