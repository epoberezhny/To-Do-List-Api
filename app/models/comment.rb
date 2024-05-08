# frozen_string_literal: true

class Comment < ApplicationRecord
  include AttachmentUploader::Attachment(:attachment)

  belongs_to :task, counter_cache: true

  validates :text, presence: true, if: -> { attachment.blank? }
  validates :attachment, presence: true, if: -> { text.blank? }
end
