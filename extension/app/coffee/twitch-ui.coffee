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
    if $('.channel-actions .js-channel-options').length
      clearInterval(checkExist)
      run()
  ), 20

$ ->
  waitForIt()

run = ->

  if $('.channel-actions .miniplayer-button').length
    return

  $miniPlayerButton = $('<div class="miniplayer-button" original-title="Mini Player" style="float: right;" />')
  $miniPlayerButton.append('<a class="button button--icon-only action" style="margin: 0;"><figure><svg class="svg-gear" height="16px" version="1.1" viewBox="0 0 16 16" width="16px" x="0px" y="0px"><path clip-rule="evenodd" d="M1,13 L8,13 L8,3 L1,3 L1,13 M8,8 L15,8 L15,3 L8,3 L8,8 M9,13 L15,13 L15,9 L9,9 L9,13 Z" fill-rule="evenodd"></path></svg></figure></a>')

  $('.channel-actions')
    .append($miniPlayerButton);

  executeInPageScope ->
    $('.channel-actions .miniplayer-button').tipsy()

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
