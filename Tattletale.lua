package.path = "./?.lua;./?/init.lua;"

require 'config'
require "irc"
require 'markovDetect'
local sleep = require "socket".sleep

local s = irc.new{nick = }

s:hook("OnChat", function(user, channel, message)
	print(("[%s] %s: %s"):format(channel, user.nick, message))
end)

function markovDetect(user, channel)
	local nick = user.nick
	local p = bayes(nick,1/10)
	if p > 0.5 then 
		s:sendChat(channel, string.format("%s is a bot! %g probabilty.", nick, p))
	else
		s:setMode("mode #lesswrong +v nick")
	end
	print(string.format("Joined: %s. Bayes: %g, Probability Real: %g, Probability Fake: %g", nick, p, probability(nick), probFake(nick)))
	print(("username: %s, host: %s, realname: %s"):format(tostring(user.username), tostring(user.host), tostring(user.realname)))
end

s:hook("OnJoin", markovDetect)


s:connect(server)

for i, channel in ipairs(channels) do
	s:join(channel)
end

while true do
	s:think()
	sleep(refeshRate)
end