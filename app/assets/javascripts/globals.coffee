$events = "ready pageshow"

window.$ready = (func) ->
  $(document).bind($events, func)