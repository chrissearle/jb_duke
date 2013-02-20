class CommandListPlugin
  include Cinch::Plugin

  set :required_options, [:conf]

  match /c/

  def usage_hint
    config[:conf]["usage"]
  end

  def execute(m)
    bot.plugins.each do |plugin|
      m.reply plugin.usage_hint if plugin.respond_to? "usage_hint"
    end
  end
end
