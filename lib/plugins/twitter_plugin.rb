class TwitterPlugin
  include Cinch::Plugin

  set :required_options, [:conf, :chan, :tweeter]

  timer 300, method: :timed

  match /tweet (.+)/

  def usage_hint
    config[:conf]["usage"]
  end

  def execute(m, message)
    tweeters = config[:conf]['tweeters'].split ','

    if tweeters.include?(m.user.nick)
      config[:tweeter].tweet(message)

      m.reply config[:conf]['tweet-owner'].format_string_with_hash({ :nick => m.user.nick })
    else
      m.reply config[:conf]['tweet-non-owner'].format_string_with_hash({ :nick => m.user.nick })
    end
  end

  def timed
    debug "Timed - check mentions"

    config[:tweeter].mentions.each do |mention|
      Channel(config[:chan]).send mention
    end
  end
end
