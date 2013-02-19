class CommandListPlugin
  include Cinch::Plugin

  match /c/

  def usage_hint
    "!c - List commands"
  end

  def execute(m)
    bot.plugins.each do |plugin|
      m.reply plugin.usage_hint if plugin.respond_to? "usage_hint"
    end
  end
end
