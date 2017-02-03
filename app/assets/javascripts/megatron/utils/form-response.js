var Form = require('compose-remote-form')
var Notify = require('compose-notification')
var Dialog = require('compose-dialog')
var Event = require('compose-toolbox').event

// Notify user of actions on ajax forms.
// Default messages are:
//
//  beforeSend: 'Submitting...',
//  success: 'Success!',
//  error: 'Something went wrong.'
//
//  You can customize form messages by nesting scripts
//  inside your form. Note, the classnames of the scripts
//  should match the message type.
//
//  <form data-remote='true'>
//    <script class='beforeSend'>Submitting form</script>
//    <script class='success'>You did it!</script>
//    <script class='error'>Try again</script>
//

var FormMessage = {
  defaultFormMessages: {
    beforeSend: 'Submitting...',
    success: 'Success!',
    error: 'Sorry, something went wrong.'
  },

  setup: function() {
    Form.on(document, {
      beforeSend: self.trigger,
      error: self.trigger,
      success: self.trigger,
    })
  },

  trigger: function(form, type, xhr) {
    var message = self.getFormMessage(form, type)

    if (!message) {
      if (xhr) {
        message = self.getResponseMessage(xhr)
      }
      message = message || self.defaultFormMessages[type]
    }

    if (type == 'beforeSend') {
      Notify.progress(message)
    } else {
      Notify[type](message)
    }

    var url = self.parseResponse(xhr, 'redirect_to')

    if (url) {
      setTimeout(function() {
        if (Turbolinks) {
          Turbolinks.visit(url)
        } else {
          window.location = url
        }
      }, 500)
    }
  },

  parseResponse: function(xhr, key) {
    try {
      return JSON.parse(xhr.responseText)[key]
    } catch (e) {
      return
    }
  },

  getResponseMessage: function(xhr) {
    var message = self.parseResponse(xhr, 'messages')

    return message
  },

  getFormMessage: function(form, type) {
    if (form.dataset[type]) {
      return form.dataset[type]
    }

    var el = form.querySelector('[data-ajax-event='+type+'], script.'+type)

    if (el) {
      return el.innerHTML
    }
  }
}


Event.ready(FormMessage.setup)

var self = FormMessage

module.exports = FormMessage
