chrome.runtime.onMessageExternal.addListener (request, sender, sendResponse) ->
  if sender.id != extensionId
    return

  sendResponse launched: true

  miniWindow = chrome.app.window.get('mini')
  playerWindow = chrome.app.window.get('player')
  chatWindow = chrome.app.window.get('chat')

  if miniWindow
    miniWindow.close()

  if playerWindow
    playerWindow.contentWindow.init(request.channel)
    playerWindow.show()

    if chatWindow
      chatWindow.contentWindow.init(request.channel)
      chatWindow.show()

  else
    chrome.app.window.create 'player.html#' + request.channel,
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