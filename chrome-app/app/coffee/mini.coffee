$ ->
  $('.expand').on 'click', ->
    chrome.app.window.current().close()
    chrome.app.window.get('player').show()
    if chrome.app.window.get('chat')
      chrome.app.window.get('chat').show()
