# Description:
#   Trello Summary functions
#
# Dependencies:
#   "node-trello": "latest"
#
# Configuration:
#   HUBOT_TRELLO_KEY - Trello application key
#   HUBOT_TRELLO_TOKEN - Trello API token
#   HUBOT_TRELLO_BOARD - The ID of the Trello board you will be working with
#
# Commands:
#   hubot trello summary - Get a basic summary of your trello board

board = {}
lists = {}
members = {}

Trello = require 'node-trello'

trello = new Trello process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN

# verify that all the environment vars are available
ensureConfig = (out) ->
    out "Error: Trello app key is not specified" if not process.env.HUBOT_TRELLO_KEY
    out "Error: Trello token is not specified" if not process.env.HUBOT_TRELLO_TOKEN
    out "Error: Trello board ID is not specified" if not process.env.HUBOT_TRELLO_BOARD
    return false unless (process.env.HUBOT_TRELLO_KEY and process.env.HUBOT_TRELLO_TOKEN and process.env.HUBOT_TRELLO_BOARD)
    true

summariseList = (res, err, data) ->
    res.reply "There was an error showing the list." if err
    points = 0
    for card in data.cards
        points += getCardPoints card unless err and data.cards.length == 0
    res.reply "Summary #{data.name}: #{data.cards.length} Cards, #{points} Points" unless err and data.cards.length == 0

getCardPoints = (card) ->
    name = card.name
    if name.indexOf("(") == 0
        closingBracketIndex = name.indexOf(")");
        number = name.substring(1, closingBracketIndex);
        return parseFloat(number);
    return 0
    

module.exports = (robot) ->
    
    ensureConfig console.log
    trello.get "/1/boards/#{process.env.HUBOT_TRELLO_BOARD}", (err, data) ->
        board = data
        trello.get "/1/boards/#{process.env.HUBOT_TRELLO_BOARD}/lists", (err, data) ->
            for list in data
                lists[list.name.toLowerCase()] = list
        trello.get "/1/boards/#{process.env.HUBOT_TRELLO_BOARD}/members", (err, data) ->
            for member in data
                members[member.fullName.toLowerCase().split " ", 1] = member
  
    robot.respond /Trello Summary/i, (res) ->
        res.reply "Looking up the cards, one sec."
        ensureConfig res.send
        for k, v of lists
            id = v.id
            trello.get "/1/lists/#{id}", {cards: "open"}, (err, data) ->
                summariseList(res, err, data)
  
    robot.respond /Trello Summarise ["“'‘](.+)["”'’]/i, (res) ->
        list_name = res.match[1]
        res.reply "Looking up the cards for #{list_name}, one sec."
        ensureConfig res.send
        id = lists[list_name.toLowerCase()].id
        res.send "I couldn't find a list named: #{list_name}." unless id
        if id
            trello.get "/1/lists/#{id}", {cards: "open"}, (err, data) ->
                summariseList(res, err, data)