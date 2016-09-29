executeInPageScope = (func) ->
  script = document.createElement('script')
  script.appendChild document.createTextNode('(' + func + ')();')
  (document.body or document.head or document.documentElement).appendChild(script)


currentUrl = window.location.href
setInterval (->
  if window.location.href != currentUrl
    currentUrl = window.location.href
    waitForIt()
), 100

window.onpopstate = (e) ->
  currentUrl = window.location.href
  waitForIt()


waitForIt = ->
  checkExist = setInterval (->
    if $('.player-buttons-right').length
      clearInterval(checkExist)
      run()
  ), 20

$ ->
  waitForIt()

run = ->

  if $('.player-buttons-right .miniplayer-button').length
    return

  $miniPlayerButton = $('<button class="miniplayer-button player-button"><span class="player-tip js-tip">Mini player</span><svg style="width: 1.8em; margin-left: 1.1em;" class="svg-gear" version="1.1" viewBox="0 0 18 12" x="0px" y="0px"><path clip-rule="evenodd" d="M0,0 L18,0 L18,12 L0,12 L0,0 Z M8,6 L18,6 L18,12 L8,12 L8,6 Z M9,7 L18,7 L18,12 L9,12 L9,7 Z" fill-rule="evenodd"></path></svg></button>');

  $('.player-buttons-right')
    .prepend($miniPlayerButton);

  $miniPlayerButton
    .on 'click', ->
      flashVideo = $('.player-video object')[0]
      html5Video = $('.player-video video')[0]
      flashVideo.pauseVideo() if flashVideo
      html5Video.pause() if html5Video

      channel = window.location.href.match(/(?:twitch.tv\/)(.*)/)[1]

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
