var Event = require('compose-event')
var Notify = require('compose-notification')

// If a page has an element .form-flash, trigger a notification
//
Event.change(function(){
  var flash = document.querySelector('.form-flash')
  if (flash) {
    var type = flash.dataset.type || 'error'
    if (type == 'info') type = 'action'
    Notify[type](flash.textContent.trim())
    flash.classList.add('hidden')
  }
})
