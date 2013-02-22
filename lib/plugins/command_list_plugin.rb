class CommandListPlugin
  include Cinch::Plugin

  set :required_options, [:conf]

  match /help/, method: :list_plugins
  match /plugins/, method: :list_plugins
  match /usage (.+)/

  def usage_hint
    config[:conf]["usage"]
  end

  def list_plugins(m)
    m.reply config[:conf]["help"].format_string_with_hash(
                {
                    :plugins => bot.plugins.select { |plugin| plugin.respond_to? "usage_hint" }.map { |plugin| plugin.class.name }.join(", ")
                })
  end

  def execute(m, plugin_name)
    p = bot.plugins.find { |plugin| plugin.class.name == plugin_name }

    if p.respond_to? "usage_hint"
      m.reply p.usage_hint
    end
  end
end
