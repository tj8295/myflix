CarrierWave.configure do |config|

  # if Rails.env.test? or Rails.env.cucumber?
  #   CarrierWave.configure do |config|
  #     config.storage = :file
  #     config.enable_processing = false
  #   end
  # end

  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',                        # required
      :aws_access_key_id      => ENV["AWS_ACCESS_KEY_ID"],                        # required
      :aws_secret_access_key  => ENV["AWS_SECRET_ACCESS_KEY"]                        # required
    }
    config.fog_directory  = 'myflix603'                     # required
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end
