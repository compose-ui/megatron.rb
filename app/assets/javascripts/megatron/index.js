var event = require('compose-event')
var notify = require('compose-notification')
var request = require('superagent')
var dialog = require('compose-dialog')
var toggler = require('compose-toggler')
var form = require('compose-remote-form') // Our UJS implementation
var esvg = require('./esvg')
var code = require('./code')

// Use Dialog for remote-form confirmation dialogs
form.confirm = dialog.show

var timeToggle = require('compose-time-toggle') // Switch time elements between local and UTC
require('compose-slider')      // Our slider (range input) component

require('./utils/activate-nav-items')
require('./utils/auto-navigate')
require('./utils/clipboard')
require('./utils/form-flash')
require('./utils/form-response')
var popMessage = require('./utils/messages')
require('./utils/text-helpers')
require('./utils/progress-bar')

require('./shims/classlist')

event.ready(function() {
  var rangeTouch = require('rangetouch')          // mobile accessiblity on sliders
  rangeTouch.set("thumbWidth", 19); 
})

event.change(function(){
  code.setup()
})

window.Megatron = module.exports = {
  dialog: dialog,
  notify: notify,
  event: event,
  form: form,
  request: request,
  esvg: esvg,
  code: CodeMirror,
  toggler: toggler,
  timeToggle: timeToggle,
  popMessage: popMessage
}
