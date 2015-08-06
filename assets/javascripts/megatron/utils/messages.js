var request = require('superagent')
var bean = require('bean')

var Messages = {
  el: function(){
    return document.querySelector('.pop-message')
  },

  fetch: function(){
    request.get('/messages.json', this.success.bind(this));
  },

  dismiss: function(event){
    self = this
    event.preventDefault()
    event.stopPropagation()

    // Track dismissal
    request.get(event.currentTarget.getAttribute('href')).end(function(response){
      // Ask for any new messages
      self.fetch()
    })
    
    // Remove element and clear cache
    this.el().remove()
    window.Megatron.accountMessage = null

  },

  success: function(response) {
    if (response.serverError) {
      return
    } else {
      var options = JSON.parse(response.text)[0]
      if(options) {
        var html = this.messageHTML(options)
        this.saveMessage(html)
        this.showMessage(html)
        bean.on(this.el(), 'click', '.dismiss', this.dismiss.bind(this))
      }
    }
  },

  messageHTML: function(options){
    options.style = options.style || ''
    var classnames = "message-content "
    if (options.style) 
      classnames += options.style
    if (options.url)
      classnames += " with-url"
    if (options.dismissable)
      classnames += " dismissable"

    var html = "<div class='"+classnames+"'>"
    if (options.dismissable)
      html += "<a href='/messages/"+options.id+"/dismiss' class='dismiss' data-no-turbolink><span class='dismiss-icon x_circle_icon'></span><span class='hidden_label'>dismiss message</span></a>"

    html += "<p>"
    if (options.url)
      html += "<a href='/messages/"+options.id+"/link'>"+options.body+"</a>"
    else
      html += options.body
    html += "</p></div>"

    return html
  },

  saveMessage: function(content){
    window.Megatron.accountMessage = content
  },

  showMessage: function(content) {
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

  load: function(){
    if(window.location.hostname.match(/app\.compose\.(io|dev)/)){
      message = window.Megatron.accountMessage
      if(!message) {
        this.fetch()
      } else {
        this.showMessage(message)
      }
    }
  }
}

module.exports = Messages
