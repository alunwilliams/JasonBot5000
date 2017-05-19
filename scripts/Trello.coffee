hubotTrello = require 'hubot-trello'

module.exports = (robot) ->
  
    robot.respond /Trello Summary (.*)/i, (res) ->
        res.reply "Looking up the cards, one sec."
        ensureConfig msg.send
        for list, i in lists
            id = list.id
            trello.get "/1/lists/#{id}", {cards: "open"}, (err, data) ->
                msg.reply "There was an error showing the list." if err
                res.reply "List: #{data.name} Total Cards: #{data.cards.length}" unless err and data.cards.length == 0