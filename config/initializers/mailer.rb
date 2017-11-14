if Rails.env.production? || Rails.env.staging?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address              => 'smtp.mailgun.org',
    :port                 => 587,
    :domain               => configatron.mailgun.mailbox.domain,
    :user_name            => configatron.mailgun.mailbox.username,
    :password             => configatron.mailgun.mailbox.password,
    :authentication       => :plain,
    :enable_starttls_auto => true
  }
  ActionMailer::Base.default from: 'no-reply@tffs.net'
  ActionMailer::Base.default_url_options = { host: 'tffs.net' }
end
