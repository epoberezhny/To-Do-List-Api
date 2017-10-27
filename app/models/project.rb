class Project < ApplicationRecord
  belongs_to :user

  has_many :tasks, dependent: :destroy

  validates :name, uniqueness: { scope: :user_id }
end
