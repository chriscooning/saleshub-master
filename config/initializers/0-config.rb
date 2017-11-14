configatron.pages.home.messages_count = 3
configatron.pages.home.news.external.count = 5
configatron.pages.home.news.internal.count = 2

configatron.dmc.assets.default_page = 1
configatron.dmc.assets.default_per = 16
configatron.dmc.timeout_sec = 5
configatron.dmc.open_timeout_sec = 5
configatron.dmc.asset_manifest_url_pattern = '%{dmc_host}/api/v1/assets/%{asset_id}/manifest.smil'

configatron.aws.enabled = false

case
  when Rails.env.development?
    configatron.dmc.host = 'http://localhost.localdomain:3001'
    configatron.dmc.user_token = 'LUCBv-UpARNnBKPUg28D'

    configatron.faye.url = 'http://107.170.36.50:8000/faye'
    configatron.faye.authentication_token = 'df2b1d51da324a3d3594ad08e4993959'
    # configatron.faye.url = 'http://127.0.0.1:9292/faye'
    # configatron.faye.authentication_token = '87f42ea0be3e958f178ab939e3801738'

    configatron.faye.channels.flashes = '10f26031950f6a8c1f0d8486622412aa'
    configatron.faye.channels.messages = '156032621978ab32142ec8d2a4448bf0'
    configatron.faye.channels.briefings = 'bc14ab2cc57842958058e66bd23eb444'
    configatron.faye.channels.whats_ups = '1bb2e16917f33674a308b8851178cc05'
    configatron.faye.channels.news = 'da87e49e5a74eaee528edaf1839bce2e'
  #configatron.dmc.host = "http://videofeedservice.com"
  #configatron.dmc.user_token = "2SWqDTWECNKVFybCjEEd"
  when Rails.env.test?
    configatron.dmc.host = 'http://localhost.localdomain:3001'
    configatron.dmc.user_token = 'LUCBv-UpARNnBKPUg28D'
  when Rails.env.staging?
    configatron.faye.url = 'http://107.170.36.50:8000/faye'
    configatron.faye.authentication_token = '####'

    configatron.faye.channels.flashes = '256ed72e56d012fb3a8deed607acedfe'
    configatron.faye.channels.messages = '0328ae8c6cd88aa04ce1f91ab5d12c66'
    configatron.faye.channels.briefings = '542a91227c1fdcb76d1bc5e1960c228f'
    configatron.faye.channels.whats_ups = '3d2d9ed99d47d8a47c7daba0be2ebb67'
    configatron.faye.channels.news = 'be1ea27db3cf8f658abc7ba8bb14c634'

    configatron.dmc.host = 'http://tfss.digitalmediacenter.com'
    configatron.dmc.user_token = '####'

    configatron.aws.enabled = true
    configatron.aws.access_key = '####'
    configatron.aws.secret_key = '####'
    configatron.aws.host = '####'
    configatron.aws.s3_bucket = 'saleshub_staging'

    configatron.mailgun.mailbox.domain = 'dmc.mailgun.org'
    configatron.mailgun.mailbox.username = 'postmaster@dmc.mailgun.org'
    configatron.mailgun.mailbox.password = '####'
  when Rails.env.production?
    configatron.faye.url = 'http://107.170.36.50:8000/faye'
    configatron.faye.authentication_token = '####'

    configatron.faye.channels.flashes = '9e3dde4e884e5aba56b31dc2dd901f2c'
    configatron.faye.channels.messages = '93dc011211924711161013dd12ed13b3'
    configatron.faye.channels.briefings = '5af7b072f97ac52539827023234fe3bb'
    configatron.faye.channels.whats_ups = '6730dd43bb450eaa90bebe98a4777831'
    configatron.faye.channels.news = '03499ada69cc253f10001fac83e5aa3c'

    configatron.dmc.host = 'http://tffs.digitalmediacenter.com'
    configatron.dmc.user_token = '####'

    configatron.aws.enabled = true
    configatron.aws.access_key = '####'
    configatron.aws.secret_key = '####'
    configatron.aws.host = '####'
    configatron.aws.s3_bucket = 'tffs'

    configatron.mailgun.mailbox.domain = 'dmc.mailgun.org'
    configatron.mailgun.mailbox.username = 'postmaster@dmc.mailgun.org'
    configatron.mailgun.mailbox.password = '####'
end
