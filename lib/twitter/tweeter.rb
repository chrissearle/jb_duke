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

    @message_formats = config['message']
  end

  def enable
    @enabled = true
    # Initialize @last_mentioned
    mentions()
  end

  def tweet(message)
    return unless @enabled

    @client.update(message)
  end

  def mentions
    return unless @enabled

    opts = {}

    opts[:since_id] = @last_mention unless @last_mention.nil?

    mentions = []

    begin
      mentions = @client.mentions(opts)
    rescue Twitter::Error::ClientError => e
      puts e.inspect
    end

    result = []

    if mentions.size > 0
      @last_mention = mentions.first.id

      result = mentions.map do |m|
        @message_formats['mention'].format_string_with_hash({:username => m.user.name,
                                                             :screenname => m.user.screen_name,
                                                             :text => m.full_text,
                                                             :id => m.id.to_s
                                                            })
      end
    end

    if opts.has_key? :since_id
      result
    else
      []
    end
  end
end