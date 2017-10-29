class AttachmentUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg png)
  end
end
