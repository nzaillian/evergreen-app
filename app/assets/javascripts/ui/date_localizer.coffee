class DateLocalizer
  constructor: ->
    @date_format = "mm/dd/yy"
    @time_format = "h:MMtt"
    @localize_dates()

  localize_dates: =>
    [date_format, time_format] = [@date_format, @time_format]
    
    $("[data-date]").each ->
      date_element = $(this)
      date = new Date(date_element.data("date"))
      date_str = date.format(date_format)
      time_str = date.format(time_format)
      formatted = "#{date_str} at #{time_str}"
      date_element.html(formatted)
      

  @preconditions: => true

$.hot DateLocalizer