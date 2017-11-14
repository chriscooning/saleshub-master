if configatron.aws.enabled
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     configatron.aws.access_key,
      aws_secret_access_key: configatron.aws.secret_key
    }
    config.fog_directory  = configatron.aws.s3_bucket
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = true
  end
end
