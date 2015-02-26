chrome.runtime.onMessageExternal.addListener (message, sender, sendResponse) ->
  if sender.id == chromeAppId and message.type == 'channel_intent'
    chrome.storage.local.get 'channel_intent', (data) ->
      if data.channel_intent
        chrome.storage.local.remove 'channel_intent'
        sendResponse channel: data.channel_intent
    return true

chrome.runtime.onMessage.addListener (message, sender, sendResponse) ->
  if message.type == 'set_channel_intent'
    chrome.storage.local.set channel_intent: message.channel

chrome.runtime.onMessage.addListener (message, sender, sendResponse) ->
  if message.type == 'open_install_popup'
    width = 300
    height = 150
    left = screen.width / 2 - (width / 2)
    top = screen.height / 2 - (height / 2)

    chrome.windows.create
      url: 'http://twitch-mini-player.s3-website-us-east-1.amazonaws.com/install.html'
      type: 'popup'
      width: width
      height: height
      left: left
      top: top
