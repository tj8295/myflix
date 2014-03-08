class SmallCoverUploader < CarrierWave::Uploader::Base
  # storage :file
  process :resize_to_fill => [166, 236]
end
