launchMiniPlayer = (channel) ->
  miniWindow = chrome.app.window.get('mini')
  playerWindow = chrome.app.window.get('player')
  chatWindow = chrome.app.window.get('chat')

  if miniWindow
    miniWindow.close()

  if playerWindow
    playerWindow.contentWindow.init(channel)
    playerWindow.show()

    if chatWindow
      chatWindow.contentWindow.init(channel)
      chatWindow.show()

  else
    chrome.app.window.create 'player.html#' + channel,
    id: 'player'
    frame: 'none'
    alwaysOnTop: true
    focused: false
    innerBounds:
      width: 275
      height: 186
      left: screen.width - 275 - 10
      top: screen.height - 186 - 10
      minWidth: 275
      minHeight: 186


chrome.runtime.onInstalled.addListener (details) ->
  if details.reason == 'install'
    chrome.runtime.sendMessage extensionId,
      type: 'channel_intent'
    , (response) ->
      if response.channel
        launchMiniPlayer(response.channel)

chrome.runtime.onMessageExternal.addListener (message, sender, sendResponse) ->
  if sender.id == extensionId and message.type == 'launch'
    sendResponse launched: true
    launchMiniPlayer(message.channel)


