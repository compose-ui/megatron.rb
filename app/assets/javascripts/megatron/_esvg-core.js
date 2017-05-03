var esvg = {
  icon: function(name, classnames) {
    var svgName = this.iconName(name)
    var element = document.querySelector('#'+svgName)

    if (element) {
      return '<svg class="svg-icon '+svgName+' '+(classnames || '')+'" '+this.dimensions(element)+'><use xlink:href="#'+svgName+'"/></svg>'
    } else {
      console.error('File not found: "'+name+'.svg" at app/assets/svgs/megatron/')
    }
  },
  iconName: function(name) {
    var before = true
    if (before) {
      return "icon-"+this.dasherize(name)
    } else {
      return name+"-icon"
    }
  },
  dimensions: function(el) {
    return 'viewBox="'+el.getAttribute('viewBox')+'" width="'+el.getAttribute('width')+'" height="'+el.getAttribute('height')+'"'
  },
  dasherize: function(input) {
    return input.replace(/[W,_]/g, '-').replace(/-{2,}/g, '-')
  },
  aliases: {"account":"account-circle-fill","kittens":"account-circle-fill","deployment-beta":"deployment-beta-line","deployment-cluster":"cluster"},
  alias: function(name) {
    var aliased = this.aliases[name]
    if (typeof(aliased) != "undefined") {
      return aliased
    } else {
      return name
    }
  }
}

// Work with module exports:
if(typeof(module) != 'undefined') { module.exports = esvg }
