init = (channel) ->
  $('.chat')
    .attr('src', 'http://www.twitch.tv/' + channel + '/chat')
    .data('channel', channel)

$ ->
  init(window.location.hash.substring(1))

  $('.button.close').on 'click', ->
    chrome.app.window.current().close()

  $('.chat').on 'loadcommit', (e) ->
    if e.originalEvent.isTopLevel
      @.insertCSS
        file: 'css/twitch-chat.css'
        runAt: 'document_start'

  chrome.app.window.get('player').onClosed.addListener ->
    chrome.app.window.current().close()
