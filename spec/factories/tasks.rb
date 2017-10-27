FactoryGirl.define do
  factory :task do
    name "MyString"
    project nil
    done false
    priority 1
    deadline "2017-10-27 01:56:24"
    comments_count 1
  end
end
