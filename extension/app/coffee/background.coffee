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
    width = 500
    height = 250
    left = Math.round(screen.availWidth / 2 - (width / 2))
    top = Math.round(screen.availHeight / 2 - (height / 2))

    chrome.tabs.create
      url: 'http://twitch-mini-player.s3-website-us-east-1.amazonaws.com/install.html'


chrome.contextMenus.create
  id: 'channel_link'
  title: 'Launch Twitch Mini Player'
  contexts: ['link']
  targetUrlPatterns: ['*://www.twitch.tv/*']

chrome.contextMenus.onClicked.addListener (info) ->
  if info.menuItemId == 'channel_link'
    channel = info.linkUrl.match(/(?:twitch.tv\/)(.*)/)[1]

    chrome.runtime.sendMessage chromeAppId,
      type: 'launch'
      channel: channel
    , (response) ->
      if not response

        chrome.runtime.sendMessage
          type: 'set_channel_intent'
          channel: channel

        chrome.runtime.sendMessage
          type: 'open_install_popup'
