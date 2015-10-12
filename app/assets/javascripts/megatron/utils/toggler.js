var bean = require('bean')
var classie = require('classie')
var _ = require('lodash')

require('compose-tap-event')
require('compose-dataset-shim')

var Toggler = {
  listen: function togglerListen(){
    bean.on(document, "click", "[data-toggle], [data-show], [data-hide], [data-toggle-class], [data-add-class], [data-remove-class]", Toggler.trigger)
    bean.on(document, "change", ".select-toggler", Toggler.trigger)
  },

  refresh: function togglerRefresh(){
    Toggler.toggleRadios()
    Toggler.toggleCheckboxes()
    Toggler.setupSelects()
  },

  trigger: function togglerTrigger(event) {
    var target = event.currentTarget

    if (target.tagName.toLowerCase() == 'a' && target.getAttribute('href') == "#") {
      event.preventDefault()
      event.stop()
    } 

    if (target.type == 'radio') {
      Toggler.toggleRadios('input[name="'+ target.name +'"]')
    } else if (target.type == 'checkbox') {
      Toggler.toggleCheckbox(target)
    } else if (target.tagName.toLowerCase() == 'select') {
      Toggler.toggleSelect(target)
    } else {
      Toggler.dispatch(target, 'hide')
      Toggler.dispatch(target, 'toggle')
      Toggler.dispatch(target, 'show')
      Toggler.dispatch(target, 'removeClass')
      Toggler.dispatch(target, 'toggleClass')
      Toggler.dispatch(target, 'addClass')
    }
  },

  dispatch: function togglerDispatch(el, type, force) {
    if (el.dataset[type]){
      if (type.match(/class/i)){
        Toggler.setClass(el.dataset[type], type, el)
      } else {
        Toggler.setState(el.dataset[type], type)
      }
    }
  },

  // Add, remove, or toggle classnames, triggered by elements with:
  //  data-hide-class, data-show-class, and data-toggle-class values
  //   
  //  Data value examples:
  //   - "classname" - add/remove/toggle classname on current element
  //   - "foo bar"   - multiple classnames, separated by spaces (like html class property)
  //   - "foo bar; selector" - change classnames on elements matched by selector
  //   - "foo bar; selector, selector" - match multiple selectors
  //

  setClass: function (selectors, action, el){
    if (typeof(action) == 'boolean') {
      action = (action ? 'addClass' : 'removeClass')
    }

    // Get selector and classnames, format: "classname classname; selector,selector"
    var settings = selectors.split(';')
    var classnames = settings[0].trim()
    var matches = []
    selectors = settings[1] || ''

    // If no slectors are present, use the current el for classnames
    if (selectors) {
      matches = document.querySelectorAll(selectors)
    }
    if (matches.length == 0) {
      if (typeof(el) == 'undefined') {
        return console.error('Cannot '+ action +' for elements matching '+selectors+'.')
      }
      matches = [el]
    }

    Array.prototype.forEach.call(matches, function(match){
      Array.prototype.forEach.call(classnames.split(' '), function(classname) {
        classie[action](match, classname)
      })
    })
  },

  setState: function togglerSetState(selectors, state) {
    var matches = document.querySelectorAll(selectors)
    if (typeof(state) == 'boolean') {
      state = (state ? 'show' : 'hide')
    }

    Array.prototype.forEach.call(matches, function(match){
      Toggler[state](match)
    })
  },

  toggle: function togglerToggle(el) {

    if (el.offsetParent === null) {
      Toggler.show(el)
    } else {
      Toggler.hide(el)
    }

  },

  show: function togglerShow(el) {
    classie.remove(el, 'hidden')
    classie.add(el, 'visible')
    var focusEl = el.querySelector('[data-focus]')

    if (focusEl) {
      focusEl.focus()
    }
  },

  hide: function togglerHide(el) {
    classie.remove(el, 'visible')
    classie.add(el, 'hidden')
  },

  toggleRadios: function togglerToggleRadio(radios) {
    var radios = radios || 'input[type=radio][data-show], input[type=radio][data-add-class]'

    Array.prototype.forEach.call(document.querySelectorAll(radios), function(radio) {
      if (radio.dataset.show)
        Toggler.setState(radio.dataset.show, radio.checked)

      if (radio.dataset.addClass)
        Toggler.setClass(radio.dataset.addClass, radio.checked)
    })
  },

  toggleCheckbox: function togglerToggeCheckbox(checkbox) {
    // Visibility toggling
    if (checkbox.dataset.hide)
      Toggler.setState(checkbox.dataset.hide, !checkbox.checked)
    if (checkbox.dataset.toggle)
      Toggler.setState(checkbox.dataset.toggle, 'toggle')
    if (checkbox.dataset.show)
      Toggler.setState(checkbox.dataset.show, checkbox.checked)

    // Class toggling
    if (checkbox.dataset.removeClass)
      Toggler.setClass(checkbox.dataset.removeClass, !checkbox.checked, checkbox)
    if (checkbox.dataset.toggleClass)
      Toggler.setClass(checkbox.dataset.toggleClass, 'toggleClass', checkbox)
    if (checkbox.dataset.addClass)
      Toggler.setClass(checkbox.dataset.addClass, checkbox.checked, checkbox)
  },

  toggleSelect: function togglerToggleSelect(select) {
    var option = select.selectedOptions[0]
    Toggler.dispatch(option, 'hide')
    Toggler.dispatch(option, 'show')
    Toggler.dispatch(option, 'addClass')
    Toggler.dispatch(option, 'removeClass')
  },

  toggleCheckboxes: function togglerToggleCheckboxes() {
    var checkboxes = 'input[type=checkbox][data-toggle]'
    Array.prototype.forEach.call(document.querySelectorAll(checkboxes), Toggler.toggleCheckbox)
  },

  // Add data-hide to each <option> containing the selectors from other
  // option's data-show. This makes the toggling of elements exclusive.
  //
  setupSelects: function togglerSetupSelects(select){
    Array.prototype.forEach.call(document.querySelectorAll('option[data-show]'), function(option){
      if (!option.dataset.hide) {

        var select = Toggler.getSelectFromOption(option)
        classie.add(select, 'select-toggler')
        var options = select.querySelectorAll('option')
        var selectors = Toggler.showAttributes(options)

        Array.prototype.forEach.call(options, function(o) {
          option.dataset.hide = _.compact(selectors.filter(function(selector){
            return option.dataset.show != selector && selector != ""
          })).join(',')
        })

        // Ensure that currently selected option is toggled properly
        //
        Toggler.toggleSelect(select)
      }
    })
  },

  // Find parent <select> for an option (accounts for option groups)
  //
  getSelectFromOption: function togglerGetSelectFromOption(el) {
    var p = el.parentElement

    if (p.tagName.toLowerCase() == 'select') {
      return p
    } else {
      return Toggler.getSelectFromOption(p)
    }
  },

  // Return an array of all data-show values from elements
  //
  showAttributes: function togglerShowAttributes(elements) {
    return Array.prototype.map.call(elements, function(el) { 
      return el.dataset.show
    })
  },

  toggleSelects: function togglerToggleSelects(selects) {
    var selects = selects || 'option[data-show]'

    Array.prototype.forEach.call(document.querySelectorAll(radios), function(radio) {
      Toggler.setState(radio.dataset.show, radio.checked)
    })
  }
}

module.exports = Toggler
