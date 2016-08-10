var event = require('compose-event')
var notify = require('compose-notification')
var request = require('superagent')
var dialog = require('compose-dialog')
var toggler = require('compose-toggler')
var form = require('compose-remote-form') // Our UJS implementation
var esvg = require('./esvg')

// Use Dialog for remote-form confirmation dialogs
form.confirm = dialog

// CodeMirror Settings
var CodeMirror = require('codemirror')
require('codemirror/mode/htmlmixed/htmlmixed')
require('codemirror/mode/slim/slim')
require('codemirror/mode/javascript/javascript')
require('codemirror/mode/css/css')
require('codemirror/mode/sql/sql')
require('codemirror/addon/runmode/runmode.js')
require('codemirror/addon/edit/matchbrackets.js')

require('compose-time-toggle') // Switch time elements between local and UTC
require('compose-slider')      // Our slider (range input) component
var rangeTouch = require('rangetouch')          // mobile accessiblity on sliders
rangeTouch.set("thumbWidth", 19); 

require('./utils/activate-nav-items')
require('./utils/auto-navigate')
require('./utils/clipboard')
require('./utils/form-flash')
require('./utils/form-notify')
require('./utils/highlight-code')
require('./utils/messages')
require('./utils/text-helpers')
require('./utils/progress-bar')

require('./shims/classlist')

window.Megatron = module.exports = {
  dialog: dialog,
  notify: notify,
  event: event,
  form: form,
  request: request,
  esvg: esvg,
  code: CodeMirror,
  toggler: toggler
}

