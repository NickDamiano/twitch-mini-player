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
    if $('.channel-actions .theatre-button').length
      clearInterval(checkExist)
      run()
  ), 20

$ ->
  waitForIt()

run = ->

  if $('.channel-actions .miniplayer-button').length
    return

  $miniPlayerButton = $('.channel-actions .theatre-button').clone()

  $miniPlayerButton
    .removeClass('theatre-button').addClass('miniplayer-button')

  $miniPlayerButton
    .find('.button')
      .attr('original-title', 'Mini Player')
      .removeAttr('data-ember-action')
      .find('path').attr('d', 'M1,13 L8,13 L8,3 L1,3 L1,13 M8,8 L15,8 L15,3 L8,3 L8,8 M9,13 L15,13 L15,9 L9,9 L9,13 Z')

  $miniPlayerButton
    .insertAfter('.channel-actions .theatre-button')

  executeInPageScope ->
    $('.channel-actions .miniplayer-button .button').tipsy()

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
