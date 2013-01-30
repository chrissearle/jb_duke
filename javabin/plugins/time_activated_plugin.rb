class TimeActivatedPlugin
  include Cinch::Plugin

  set :required_options, [:chan]

  listen_to :time_activated

  def listen(m, message)
    Channel(config[:chan]).send message
  end
end
