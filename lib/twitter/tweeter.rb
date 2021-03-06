class Tweeter
  def initialize(config, logfile = $stdout)
    self.configure(config)
    @logfile = logfile
    @enabled = false
  end

  def configure(config)
    @accounts = {}

    config.each do |c|
      key = c['name'].downcase.to_sym

      @accounts[key] = {
          :client => Twitter::Client.new(
              :consumer_key => c['tokens']['consumer']['token'],
              :consumer_secret => c['tokens']['consumer']['secret'],
              :oauth_token => c['tokens']['access']['token'],
              :oauth_token_secret => c['tokens']['access']['secret']
          ),
          :messages => c['message'],
          :lastmention => nil
      }
    end
  end

  def enable
    @enabled = true

    log_msg 'Enabling twitter'

    # Initialize @last_mentioned
    mentions()
  end

  def tweet(name, message)
    return unless @enabled

    return unless @accounts.has_key?(name)

    @accounts[name][:client].update(message)
  end

  def accounts
    return [] unless @enabled

    @accounts.map { |k, v| k.to_s }
  end

  def mentions
    return unless @enabled

    m = []

    @accounts.each do |name, account|
      m.concat(mentions_for(name))
    end

    m
  end

  def mentions_for(name)
    return unless @enabled

    return unless @accounts.has_key?(name)

    opts = {}

    opts[:since_id] = @accounts[name][:lastmention] unless @accounts[name][:lastmention].nil?

    m = []

    begin
      m = @accounts[name][:client].mentions(opts)
    rescue Twitter::Error::ClientError => e
      log_msg e.inspect
    end

    result = []

    if m.size > 0
      @accounts[name][:lastmention] = m.first.id

      result = m.map do |msg|
        @accounts[name][:messages]['mention'].format_string_with_hash({:username => msg.user.name,
                                                                       :screenname => msg.user.screen_name,
                                                                       :text => msg.full_text,
                                                                       :id => msg.id.to_s
                                                                      })
      end
    end

    result
  end

  private

  def log_msg(msg)
    @logfile.write("\n\nTWITTER: #{msg}\n\n")
  end
end