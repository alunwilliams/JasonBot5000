# Description
#   Some Hello World type scripts
#
# Configuration:
#
# Commands:
#   hubot Hello - Say Hello to hubot
#   hubot Say <phrase> - Make JasonBot say something. Please watch your language
#
# Notes:
#

module.exports = (robot) ->

    robot.hear /Hello JasonBot.*/i, (res) ->
        res.send "Hello World!"

    robot.respond /Hello/i, (res) ->
        res.reply "Hello World!"
    
    robot.respond /Say (.*)/i, (res) ->
        whatToSay = res.match[1]
        res.reply "Ok then. #{whatToSay}"