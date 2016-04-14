require 'telegram_bot'
require 'twitter'

def config
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "CONSUMER_KEY"
  config.consumer_secret     = "CONSUMER_SECRET"
  config.access_token        = "ACCESS_TOKEN"
  config.access_token_secret = "ACCESS_TOKEN_SECRET"
end
return client
end

def tweets
  client = config
  return client.user_timeline("2010MisterChip").take(5)
end

bot = TelegramBot.new(token: 'TELEGRAM_BOT_KEY')
bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

  sample = tweets
  content = " "
  message.reply do |reply|
    case command
    when /last5/i
      sample.each do |tweet|
        content += "@MisterChip: #{tweet.text}\n\n"
      end
        reply.text = content
    else
      reply.text = "#{message.from.first_name}, have no idea what #{command.inspect} means."
    end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
