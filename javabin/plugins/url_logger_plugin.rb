class UrlLoggerPlugin
  include Cinch::Plugin

  set :required_options, [:mongo]

  listen_to :channel
  
  def listen(m)
    collection = config[:mongo].collection('urls')
  
    urls = URI.extract(m.message, ['http', 'https', 'ftp', 'mailto'])
    
    urls.each do |url|
      data = { 'url' => url, :nick => m.user.nick, :time => m.time }
      
      if m.channel?
        data['channel'] = m.channel.name
      end

      collection.insert(data)
    end
  end
end
