# coding: utf-8

require 'net/irc'
require 'config.rb'

class NBot < Net::IRC::Client

  def on_rpl_welcome(m)
    OPTIONS['channels'].each do |channel|
      post(JOIN, channel)
    end
  end

  def on_privmsg(m)
    super
    channel, message = *m
    m.prefix =~ /^(.+?)\!/
    nick = $1
    now = Time.now
    ch = channel.sub(/^\#/, '')
    message.force_encoding("UTF-8")
    if rand(100) == 0
      answer = (rand(10) != 0) ? "はい" : "いいえ"
      if nick
        message = "#{nick}: #{answer}"
      else
        message = answer
      end
      post(NOTICE, channel, message)
    end
  end

end

#Process.daemon(true)

NBot.new(OPTIONS[:host], OPTIONS[:port],
         nick: OPTIONS[:nick],
         user: OPTIONS[:user],
         real: OPTIONS[:real]).start
