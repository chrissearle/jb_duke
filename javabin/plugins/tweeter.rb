class Tweeter
  def initialize(config)
    self.configure(config)
    @last_mention = nil
    @enabled = false
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

  def enable
    @enabled = true
    # Initialize @last_mentioned
    mentions()
  end

  def tweet(name, place)
    return unless @enabled

    message = I18n.l Time.now, :format => @message_format

    message = message.gsub(/LOC/, name).gsub(/PLACE/, place)

    @client.update(message)
  end

  def mentions
    return unless @enabled

    opts = {}

    opts[:since_id] = @last_mention unless @last_mention.nil?

    mentions = @client.mentions(opts)

    if mentions.size > 0
      @last_mention = mentions.first.id
    end

    if opts.has_key? :since_id
      mentions.map do |m|
        "Mentioned: #{m.user.screen_name} - #{m.full_text}"
      end
    else
      []
    end
  end
end