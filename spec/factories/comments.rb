# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    sequence(:text) { |n| "My text #{n}" }
    task
  end
end
