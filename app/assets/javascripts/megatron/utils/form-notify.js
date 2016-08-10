var Form = require('remote-form')
var Notify = require('notify')
var Dialog = require('compose-dialog')

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

var defaultMessages = {
  beforeSend: 'Submitting...',
  success: 'Success!',
  error: 'Something went wrong.'
}

var extractMessage = function(xhr) {
  try {
    return JSON.parse(xhr.responseText).messages
  } catch (e) {
    if (xhr.statusText && xhr.statusText.length > 0) {
      return xhr.statusText
    }
  }
}

var notifyForm = function(form, type, xhr) {
  var message = getMessage(form, type)

  if (!message) {
    if (xhr) {
      message = extractMessage(xhr)
    }
    message = message || defaultMessages[type]
  }

  if (type == 'beforeSend')
    Notify.progress(message)
  else
    Notify[type](message)
}

var getMessage = function(form, type) {
  if (form.dataset[type])
    return form.dataset[type]

  var el = form.querySelector('[data-ajax-event='+type+'], script.'+type)

  if (el)
    return el.innerHTML
}

Form.on(document, {
  beforeSend: notifyForm,
  error: notifyForm,
  success: notifyForm,
})

Form.confirm = Dialog
