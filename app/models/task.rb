# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :project

  has_many :comments, dependent: :destroy

  validates :name, presence: true

  acts_as_list column: :priority, scope: :project
end
