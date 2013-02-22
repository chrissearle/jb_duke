class AboutPlugin
  include Cinch::Plugin

  set :required_options, [:conf]

  match /about/

  def usage_hint
    config[:conf]["usage"]
  end

  def execute(m)
    m.reply config[:conf]["about"]
  end
end
