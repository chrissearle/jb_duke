class Tweeter
  def initialize(config)
    self.configure(config)
  end

  def configure(config)
    Twitter.configure do |conf|
      conf.consumer_key = config['consumer']['token']
      conf.consumer_secret = config['consumer']['secret']
      conf.oauth_token = config['access']['token']
      conf.oauth_token_secret = config['access']['secret']
    end

    @client = Twitter::Client.new

    @message_format = config['message']['format']
  end

  def tweet(name, place)
    message = I18n.l Time.now, :format => @message_format

    message = message.gsub(/LOC/, name).gsub(/PLACE/, place)

    @client.update(message)
  end
end