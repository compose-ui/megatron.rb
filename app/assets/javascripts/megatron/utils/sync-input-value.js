var toolbox = require( 'compose-toolbox' )
var Event = toolbox.event
var textSelectors = 'textarea, input[type=url], input[type=tel], input[type=text], input[type=email], input[type=number], input[type=password]'

Event.bubbleFormEvents()

function textInputs() {
  return document.querySelectorAll( textSelectors )
}

function syncValue( input ) {

  // Allow calling from event handler
  if ( input.target ) { input = input.target }

  // If element only contains whitespace, strip value
  if ( !input.value.replace( /\s/g, '' ).length ) { input.value = ''; }

  input.setAttribute( 'value', input.value )

}

Event.change( function() {

  // Ensure that all inputs have a value
  toolbox.each( textInputs(), syncValue )

})

Event.on( document, 'blur', 'input', syncValue )
