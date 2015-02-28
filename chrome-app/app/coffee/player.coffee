init = (channel) ->
  $('.player')
    .attr('src', 'http://www.twitch.tv/' + channel + '/popout')
    .data('channel', channel)

$ ->
  init(window.location.hash.substring(1))

  $('.player').on 'loadcommit', (e) ->
    if e.originalEvent.isTopLevel
      @.insertCSS
        code: 'body { overflow: hidden }'
        runAt: 'document_start'

  $('.button.close').on 'click', ->
    chrome.app.window.current().close()
    if chrome.app.window.get('chat')
      chrome.app.window.get('chat').close()

  $('.button.open-page').on 'click', ->
    channel = $('.player').data('channel')
    window.open 'http://www.twitch.tv/' + channel

  $('.button.chat').on 'click', ->
    chrome.storage.local.set 'chat': true
    $('.button.chat').hide()
    chrome.app.window.create 'chat.html#' + $('.player').data('channel'),
      id: 'chat'
      frame: 'none'
      alwaysOnTop: true
      focused: false
      innerBounds:
        width: 275
        height: 340
        left: screen.availWidth - 275 - 10
        top: screen.availHeight - 340 - 10 - 155 - 10
        minWidth: 275
        minHeight: 200
    , (w) ->
      w.onClosed.addListener ->
        chrome.storage.local.set 'chat': false
        $('.button.chat').show()

  chrome.storage.local.get 'chat', (data) ->
    if typeof data.chat is 'undefined' or data.chat == true
      $('.button.chat').trigger 'click'

  $('.button.mini').on 'click', ->
    playerWindowInnerBounds = chrome.app.window.current().innerBounds

    chrome.app.window.create 'mini.html',
      id: 'mini'
      frame: 'none'
      alwaysOnTop: true
      focused: false
      resizable: false
      innerBounds:
        width: 114
        height: 50
        left: playerWindowInnerBounds.left + playerWindowInnerBounds.width - 114
        top: playerWindowInnerBounds.top + playerWindowInnerBounds.height - 50

    chrome.app.window.current().hide()

    if chrome.app.window.get('chat')
      chrome.app.window.get('chat').hide()
