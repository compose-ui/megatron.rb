var toolbox = require('compose-toolbox')
var Event = toolbox.event

// This handles the process of adding to clipboard,
// handling failure states, and hiding buttons when
// clipboard access is not supported.

// event handler
function copy( event ) {

  // find target element
  var trigger = event.target,
      target;
  
  event.preventDefault();
  
  target = document.querySelector( trigger.dataset.copyTarget )

  if ( !target ) { return }

  target.select()

  // Copy text
  try {

    document.execCommand( 'copy' )

    target.blur()
    trigger.classList.add( 'copied' )
    
  // Change style for failure
  } catch ( err ) {
    trigger.classList.add( 'copy-failed' )
  }

  // Cleanup
  Event.delay( function() { 
    trigger.classList.remove( 'copied' )
    trigger.classList.remove( 'copy-failed' )
  }, 2000 )
}

Event.change( function() {
  if ( document.queryCommandSupported( 'copy' ) ) {

    Event.on( document, 'click', '[data-copy-target]', copy, { useCapture: true } )

  } else {

    toolbox.each( document.querySelectorAll( '[data-copy-target]' ), function( el ) {
      el.removeAttribute('data-copy-target')
    })
  }
})
