class Comment < ApplicationRecord
  mount_uploader :attachment, AttachmentUploader

  belongs_to :task, counter_cache: true

  validates :text, presence: true, if: -> { attachment.blank? }
  validates :attachment, presence: true, if: -> { text.blank? }
end
