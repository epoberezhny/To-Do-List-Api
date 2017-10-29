class Task < ApplicationRecord
  include RankedModel
  
  belongs_to :project

  has_many :comments, dependent: :destroy

  validates :name, presence: true

  ranks :priority, with_same: :project_id
end
