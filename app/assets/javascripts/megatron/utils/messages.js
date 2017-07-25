var request = require('superagent')
var Event = require('compose-event')

// Look for messages at /messages.json
// (an internal json document which we use to publish site-wide messages)
// Then pin the topmost message to the top of the page.

var Messages = {
  el: function messagesEl(){
    return document.querySelector('.pop-message')
  },

  fetch: function messagesFetch(){
    request.get('/messages.json').end(this.end.bind(this));
  },

  link: function messagesDismiss(event){
    var url = event.currentTarget.getAttribute('href'),
      tokenMeta = document.querySelector('meta[name="csrf-token"]'),
      token = tokenMeta && tokenMeta.getAttribute('content'),
      self = this;

    event.preventDefault()
    event.stopPropagation()

    request
      .patch(url)
      .set('X-CSRF-Token', token)
      .end(function(error, response){
        if (error || response.serverError) {
          return
        }
        if (response.body) {
          window.location = response.body.url
        }
      })
  },

  dismiss: function messagesLink(event){
    var url = event.currentTarget.getAttribute('href'),
      tokenMeta = document.querySelector('meta[name="csrf-token"]'),
      token = tokenMeta && tokenMeta.getAttribute('content'),
      self = this;

    event.preventDefault()
    event.stopPropagation()

    request
      .patch(url)
      .set('X-CSRF-Token', token)
      .end(function(error, response){
      // Ask for any new messages
      self.fetch()
    })
    
    // Remove element and clear cache
    this.el().remove()
    window.Megatron.accountMessage = null

  },

  end: function messagesEnd(error, response) {
    if (error || response.serverError) {
      return
    } else {
      var message = JSON.parse(response.text)['_embedded']['messages'][0]
      if(message) {
        var html = this.messageHTML(message)
        this.saveMessage(html)
        this.showMessage(html)
        Event.on(this.el(), 'click', '.dismiss', this.dismiss.bind(this))
        Event.on(this.el(), 'click', '.link', this.link.bind(this))
      }
    }
  },

  messageHTML: function messagesMessageHTML(message){
    message.style = message.style || ''
    var classnames = "message-content "
    if (message.style)
      classnames += message.style
    if (message.url)
      classnames += " with-url"
    if (message.is_dismissable)
      classnames += " dismissable"

    var html = "<div class='"+classnames+"'>"
    if (message.is_dismissable)
      html += "<a href='/messages/"+message.id+"' class='dismiss' data-no-turbolink><span class='dismiss-icon'></span><span class='hidden_label'>dismiss message</span></a>"

    html += "<p>"
    if (message.url)
      html += "<a href='/messages/"+message.id+"' class='link'>"+message.body+"</a>"
    else
      html += message.body
    html += "</p></div>"

    return html
  },

  saveMessage: function messagesSaveMessage(content){
    window.Megatron.accountMessage = content
  },

  showMessage: function messagesShowMessage(content) {
    if(this.el()) {
      this.el().innerHTML = content
    } else {
      var header = document.querySelector('.site-header')
      
      // if message display isn't disabled by data-no-messages=true
      if (header.dataset.noMessages == null) { 
        header.innerHTML = "<div class='pop-message'>"+content+"</div>" + header.innerHTML
      }
    }
  },

  load: function messagesLoad(){
    if(window.location.hostname.match(/app\.compose/)){
      var message = window.Megatron.accountMessage
      if(!message) {
        Messages.fetch()
      } else {
        Messages.showMessage(message)
      }
    }
  }
}

module.exports = Messages
Event.ready(Messages.load)
