# frozen_string_literal: true

class AttachmentUploader < Shrine
  Attacher.validate do
    validate_max_size 10.megabytes
    validate_mime_type %w[image/jpeg image/png]
    validate_extension %w[jpg jpeg png]
  end
end
