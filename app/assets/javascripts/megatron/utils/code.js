var highlighter = require('compose-code-highlighter')

CodeMirror.highlighter = highlighter
CodeMirror.highlight = highlighter.highlight
// CodeMirror Settings
var CodeMirror = require('codemirror')
require('codemirror/mode/htmlmixed/htmlmixed')
require('codemirror/mode/slim/slim') require('codemirror/mode/javascript/javascript')
require('codemirror/mode/css/css')
require('codemirror/mode/sql/sql')
require('codemirror/addon/runmode/runmode.js')
require('codemirror/addon/edit/matchbrackets.js')

highlighter.addAlias({ pgsql: 'text/x-pgsql' })

var editorDefaults = {
  indent: 2,
  matchBrackets: true,
  lineWrapping: true
}

function getOptions ( el ) {
  var lang = highlighter.aliasLang( el.dataset.lang || 'plain' ),

  return {
    mode: lang,
    indent: el.dataset.indent,
    lineWrapping: el.dataset.wrap,
    matchBrackets: el.dataset.matchBrackets
  }
}

function newEditor ( el ) {
  var options = Object.assign( {}, editorDefaults, getOptions( el ))

  CodeMirror.fromTextArea( el, options )
}

function setup (){

  highlighter.highlight()

  var inputs = document.querySelector('textarea[data-lang]')
  Array.prototype.forEach.call( inputs, newEditor )
}


var code = CodeMirror
code.highlighter = highlighter
code.highlight = highlighter.highlight
code.addAlias = highlighter.addAlias
code.getMode = highlighter.aliasLang
code.setup = setup

module.exports = code
