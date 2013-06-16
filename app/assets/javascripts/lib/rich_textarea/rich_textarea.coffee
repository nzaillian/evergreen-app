#= require ./template

class RichTextarea
  constructor: (@originalEl) ->
    @el = $(window.rta.template)
    @originalEl.hide()

    index = @originalEl.parent().index(@originalEl)

    @originalEl.parent().append(index, @el)

$.fn.richTextarea = ->
  if $(this).data("richTextarea")?
    return $(this).data("richTextarea")
  else
    $(this).data("richTextarea", new RichTextarea($(this)))

