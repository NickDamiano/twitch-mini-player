$ ->
  $('.player')[0].request.onBeforeRequest.addListener ((details) ->
    #console.log details
    return { cancel: true }
  ),
  {
    urls: [
      '*://*.liverail.com/*'
      '*://*.doubleclick.net/*'
    ]
  },
  ['blocking']
