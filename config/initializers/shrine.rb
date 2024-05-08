# frozen_string_literal: true

Shrine.plugin :activerecord
Shrine.plugin :validation_helpers
Shrine.plugin :instrumentation
Shrine.plugin :determine_mime_type
Shrine.plugin :pretty_location
Shrine.plugin :upload_endpoint, max_size: 10.megabytes

case Rails.env
when 'production'
  require 'shrine/storage/file_system'

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::Cloudinary.new
  }
when 'development'
  require 'shrine/storage/file_system'

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads')
  }
when 'test'
  require 'shrine/storage/memory'

  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new
  }
end
