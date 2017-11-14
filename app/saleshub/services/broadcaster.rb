class Services::Broadcaster < ::Services::Base
  def self.broadcast(channel_name, data)
    message = {
      channel: "/channels/#{configatron.faye.channels.send(channel_name)}",
      data:    data,
      authentication_token: configatron.faye.authentication_token
    }

    uri = URI.parse(configatron.faye.url)
    Net::HTTP.post_form(uri, :message => message.to_json)
  end
end