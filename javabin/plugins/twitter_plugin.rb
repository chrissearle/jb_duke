class TwitterPlugin
  include Cinch::Plugin

  set :required_options, [:chan, :tweeter]

  timer 300, method: :timed

  def timed
    debug "Timed - check mentions"

    config[:tweeter].mentions.each do |mention|
      Channel(config[:chan]).send mention
    end
  end
end
