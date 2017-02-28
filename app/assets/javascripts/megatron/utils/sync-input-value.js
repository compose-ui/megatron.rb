var toolbox = require( 'compose-toolbox' )
var Event = toolbox.event
var textSelectors = 'textarea, input:not([type=radio]):not([type=checkbox]):not([type=range]):not([type=hidden]):not([type=submit]):not([type=image]):not([type=reset])'

function syncValue( input ) {

  // Allow calling from event handler
  input = ( input.target || input )

  // If element is empty (or contains only whitespace)
  // Add empty class
  input.classList.toggle( 'empty', !input.value.trim().length )
}

// Initialize input state
Event.change( function() {
  toolbox.each( document.querySelectorAll( textSelectors ), syncValue )
})

// Set input state on keyup (debounced)
Event.on( document, 'keyup', textSelectors, Event.debounce( syncValue, 100 ) )
