class Comment < ApplicationRecord
  mount_uploader :attachment, AttachmentUploader

  belongs_to :task, counter_cache: true
end
