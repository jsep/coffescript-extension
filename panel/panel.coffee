sourceFragment = "try:"

# Set up the compilation function, to run when you stop typing.
compileSource = ->
  source = $('#repl_source').val()
  results = $('#repl_results')
  window.compiledJS = ''
  try
    window.source = source
    window.compiledJS = CoffeeScript.compile source, bare: on
    el = results[0]
    if el.innerText
      el.innerText = window.compiledJS
    else
      results.text(window.compiledJS)
    results.removeClass 'error'
    $('.minibutton.run').removeClass 'error'
  catch {location, message}
    if location?
      message = "Error on line #{location.first_line + 1}: #{message}"
    results.text(message).addClass 'error'
    $('.minibutton.run').addClass 'error'

  
# Listen for keypresses and recompile.
$('#repl_source').keyup -> compileSource()

# Eval the compiled js.
evalJS = ->
  try
    chrome.devtools.inspectedWindow.eval(
      window.compiledJS,
      (result, isException) ->
         if (isException)
          console.log("Fail eval: "+msg.text);
         else
   	      chrome.experimental?.devtools.console.addMessage("log", window.source)
    )
  catch error then alert error

# Load the console with a string of CoffeeScript.
window.loadConsole = (coffee) ->
  $('#repl_source').val coffee
  compileSource()
  $('.navigation.try').addClass('active')
  false


$('.minibutton.run').click -> evalJS()

# Bind navigation buttons to open the menus.
$('.navigation').click (e) ->
  return if e.target.tagName.toLowerCase() is 'a'
  return false if $(e.target).closest('.repl_wrapper').length
  if $(this).hasClass('active')
    closeMenus()
  else
    closeMenus()
    $(this).addClass 'active'
  false

# Dismiss console if Escape pressed or click falls outside console
# Trigger Run button on Ctrl-Enter
$(document.body)
  .keydown (e) ->
    closeMenus() if e.which == 27
    evalJS() if e.which == 13 and (e.metaKey or e.ctrlKey) and $('.minibutton.run:visible').length
  .click (e) ->
    return false if $(e.target).hasClass('minibutton')
    closeMenus()

$("#repl_permalink").click (e) ->
    window.location = $(this).attr("href")
    false

# If source code is included in location.hash, display it.
hash = decodeURIComponent location.hash.replace(/^#/, '')
if hash.indexOf(sourceFragment) == 0
    src = hash.substr sourceFragment.length
    loadConsole src

compileSource()