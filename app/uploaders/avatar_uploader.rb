# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include Sprockets::Rails::Helper

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_fill => [96, 96]

  version :thumb do
    process :resize_to_fill => [30, 30]
  end

  version :small do
    process :resize_to_fill => [48, 48]
  end

  version :med do
    process :resize_to_fill => [96, 96]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end


  def default_url
    asset_path("/assets/common/no_avatar.jpg")
  end
end
