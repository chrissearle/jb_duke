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

  def tweet(name, place)
    return unless @enabled

    message = I18n.l Time.now, :format => @message_formats['beer']

    message = format_string(message, {
        :loc => name,
        :place => place
    })

    @client.update(message)
  end

  def mentions
    return unless @enabled

    opts = {}

    opts[:since_id] = @last_mention unless @last_mention.nil?

    mentions = @client.mentions(opts)

    result = []

    if mentions.size > 0
      @last_mention = mentions.first.id

      result = mentions.map do |m|
        format_string(@message_formats['mention'], {
            :username => m.user.name,
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

  def format_string(template, params)
    result = template

    params.each do |key, val|
      match = key.to_s.upcase
      result = result.gsub(/#{match}/, val)
    end

    result
  end
end