$ ->
  $('.button.maxi').on 'click', ->
    chrome.app.window.current().close()
    chrome.app.window.get('player').show()
    if chrome.app.window.get('chat')
      chrome.app.window.get('chat').show()

  $('.button.close').on 'click', ->
    chrome.app.window.current().close()
    if chrome.app.window.get('player')
      chrome.app.window.get('player').close()
    if chrome.app.window.get('chat')
      chrome.app.window.get('chat').close()
