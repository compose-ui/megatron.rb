var toolbox     = require('compose-toolbox')
var notify      = require('compose-notification')
var request     = require('superagent')
var dialog      = require('compose-dialog')
var code        = require('./utils/code')
var toggler     = require('compose-toggler')
var form        = require('compose-remote-form') // Our UJS implementation
var esvg        = require('./_svg')
var highlighter = require('compose-code-highlighter')

// Use Dialog for remote-form confirmation dialogs
form.confirm   = dialog.show

// formUP has our validator and progressive form utlitity
var formUp     = require('compose-form-up')
form.next      = formUp.next
form.validate  = formUp.validate

var timeToggle = require('compose-time-toggle') // Switch time elements between local and UTC
require('compose-slider')      // Our slider (range input) component

require('./utils/activate-nav-items')
require('./utils/sync-input-value')
require('./utils/auto-navigate')
require('./utils/clipboard')
require('./utils/form-flash')
require('./utils/form-response')
var popMessage = require('./utils/messages')
require('./utils/text-helpers')
require('./utils/progress-bar')

require('./vendor/bugsnag')

toolbox.event.ready(function() {
  var rangeTouch = require('rangetouch')          // mobile accessiblity on sliders
  rangeTouch.set("thumbWidth", 19); 

  // Simplify bugsnag integration
  var bugsnagTag = document.querySelector('meta[data-api-key]')
  if ( bugsnagTag ) { 
    Bugsnag.apiKey = bugsnagTag.dataset.apiKey
  }

})

toolbox.event.change(function(){
  code.setup()
})

var Megatron = toolbox.merge( {
  dialog: dialog,
  notify: notify,
  form: form,
  request: request,
  esvg: esvg,
  code: code,
  toggler: toggler,
  timeToggle: timeToggle,
  popMessage: popMessage
}, toolbox )

window.Megatron = module.exports = Megatron
