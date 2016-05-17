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

  $miniPlayerButton = $('<div class="inline miniplayer-button" original-title="Mini Player" />')
  $miniPlayerButton.append('<a class="button glyph-only action" style="margin: 0;"><svg class="svg-gear" height="16px" version="1.1" viewBox="0 0 16 16" width="16px" x="0px" y="0px"><path clip-rule="evenodd" d="M1,13 L8,13 L8,3 L1,3 L1,13 M8,8 L15,8 L15,3 L8,3 L8,8 M9,13 L15,13 L15,9 L9,9 L9,13 Z" fill-rule="evenodd"></path></svg></a>')

  $miniPlayerButton
    .insertAfter('.channel-actions .ember-view:last-child')

  executeInPageScope ->
    $('.channel-actions .miniplayer-button').tipsy()

  $miniPlayerButton
    .on 'click', ->
      $('#player object')[0].pauseVideo()

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
