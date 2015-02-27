if 'update_url' of chrome.runtime.getManifest() # prod
  chromeAppId = 'efgochcggfpajofoidkjhelkaihdflpo'
else # dev
  if navigator.appVersion.indexOf('Win') >= 0
    chromeAppId = 'pmkokjeihmijcgickeeibnbgkldhpiip'
  else
    chromeAppId = 'ompflmhoamndmnjgfkcglfbciooccidk'
