module.exports = (robot) ->

    robot.hear /Hello JasonBot500/i, (res) ->
        res.send "Hello World!"

    robot.respond /Hello/i, (res) ->
        res.reply "Hello World!"
    
    robot.respond /Say (.*)/i, (res) ->
        whatToSay = res.match[1]
        res.reply "Ok then. #{whatToSay}"