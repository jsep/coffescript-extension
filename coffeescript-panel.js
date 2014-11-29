
// Create CoffeScript panel in devtools
// see: https://developer.chrome.com/extensions/devtools_panels
chrome.devtools.panels.create(
  'CoffeeScript', // panel title
  null, // icon path
  'panel/panel.html', // page path
  function(panel) {
    console.debug("loaded")
  });