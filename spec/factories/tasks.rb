# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Task #{n}" }
    project
  end
end
