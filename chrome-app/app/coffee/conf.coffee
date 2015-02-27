if 'update_url' of chrome.runtime.getManifest() # prod
  extensionId = 'fjeahcfaibacboijpccppebdpihhbflk'
else # dev
  if navigator.appVersion.indexOf('Win') >= 0
    extensionId = 'bffdjjiapibkimbfedaclkfipoipkool'
  else
    extensionId = 'ogbjgjanjbmefafepbdfpbnknangapnk'
