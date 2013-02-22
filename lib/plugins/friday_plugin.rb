class FridayPlugin
  include Cinch::Plugin

  set :required_options, [:conf]

  match /isitfriday\?/

  def usage_hint
    config[:conf]["usage"]
  end

  def execute(m)
    dow = (I18n.l Time.now, :format => '%u').to_i

    if dow == 5
      m.reply config[:conf]["friday"]
    else
      m.reply config[:conf]["not-friday"]
    end
  end
end
