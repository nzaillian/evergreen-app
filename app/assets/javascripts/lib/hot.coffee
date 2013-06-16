# Hot.coffee is a CoffeeScript anti-framework for server-rendered web applications. 
# If you like to server-render as much of your apps as you can get away with
# and dress up pages with javascript for any UX you can't achieve in other ways,  
# then this anti-framework is for you. If you're looking for
# a comprehensive client-side MVC framework or similar, it definitely
# is not (and you might even say is philosophically opposed).
#
# Is this a joke? No, not really.
#
# How does it work? 
#
# Well, it does not do very much. 
# Hot.coffee exposes a simple harness (via the "$.hot"
# function) to acommodate the anti-pattern (or so some might call 
# it) of using classes as nothing but a container for procedural logic
# on your page. You expose a "preconditions" function on a class
# (this might check for a body class or some other indication of context)
# and if the preconditions are met, Hot.coffee creates an instance of the 
# class. If you're using Hot.coffee with Turbolinks, you may wish to define
# a "destroy" function on your class in which you cleanup any resources
# that you'd like to cleanup before new instances of the class are created.
# This function will be called automatically.

window.$turbolinks_events ?= "ready page:change page:restore"

# set default config options (all options already
# set on $hot_coffee_config will not be overwritten)
window.$hot_coffee_config = $.extend({
  turbolinks: true
}, window.$hot_coffee_config || {})

# alias in local closure for brevity 
config = window.$hot_coffee_config

if config.turbolinks == true
  ready_events = $turbolinks_events
else
  ready_events = "ready pageshow"

# define an $.hot function to act 
# as a simple harness for classes
# written in the Hot.coffee style
window.$.hot = (klass) ->

  $ready ->

    # derive window-global variable name from 
    # an explicit __name__ if the user has set 
    # one on the class, else defer to the
    # "name" attribute supplied by coffee
    
    if klass.__name__?
      klass_name = klass.__name__
    else
      klass_name = klass.name

    inst_name = "_#{klass_name}"

    # cleanup existing if present
    if window[inst_name]? and window[inst_name].destroy?
      window[inst_name].destroy()
    
    window[inst_name] = null
    
    # initialize new instance if preconditions
    # for initialization are met
    if klass.preconditions() == true
      # initialize new
      window[inst_name] = new klass