module.exports = (robot) ->

    robot.respond /Trello Summary/i, (res) ->
        url = "boards/kkMICugu/cards"
        key = "ed2bca93fc96baf1026788d7d661b83d"
        token = "964af7bf50973d664c142e064c2d458a38a22a47dad4bceda9ded804be8e178b"
        completeUri = "https://api.trello.com/1/#{url}?key=#{key}&token=#{token}"
        responseObj = readJsonFromUrl(completeUrl);
        res.reply "No of Cards = #{Object.Keys(object)}"