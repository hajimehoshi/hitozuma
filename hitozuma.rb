# coding: utf-8

require 'net/irc'
require 'config.rb'

class NBot < Net::IRC::Client

  def on_rpl_welcome(m)
    enc = OPTIONS[:encode]
    OPTIONS[:channels].zip(OPTIONS[:channel_passes]) do |channel, pass|
      if pass
        #post(JOIN, channel.encode(enc), "+k", pass.encode(enc))
        post(JOIN, channel.encode(enc), pass.encode(enc))
      else
        post(JOIN, channel.encode(enc))
      end
    end
  end

  def on_privmsg(m)
    super
    enc = OPTIONS[:encode]
    channel, message = *m
    m.prefix =~ /^(.+?)\!/
    nick = $1
    now = Time.now
    ch = channel.sub(/^\#/, '')
    message.force_encoding(enc).encode(Encoding::UTF_8)
    if rand(100) == 0
      answer = (rand(10) != 0) ? "はい" : "いいえ"
      if nick
        message = "#{nick}: #{answer}"
      else
        message = answer
      end
      post(NOTICE, channel, message.encode(enc))
    end
  end

end

Process.daemon(true)

NBot.new(OPTIONS[:host], OPTIONS[:port],
         nick: OPTIONS[:nick],
         user: OPTIONS[:user],
         real: OPTIONS[:real]).start
