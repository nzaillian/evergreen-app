class Question
  constructor: ->
    @_bind_events()

  _bind_events: =>
    $(".score-box").click(@_vote)

  _vote: (e) =>
    e.preventDefault()
    link = $(e.currentTarget)

    if link.hasClass("voted")
      # remove the vote
      $.ajax
        type: "DELETE"
        url: link.data("url")
        success: (data) =>
          if data.status == "success"
            link.removeClass("voted")
            link.find(".score").html(data.total)

    else
      # add vote
      $.ajax
        type: "POST"
        url: link.data("url")
        success: (data) =>
          if data.status == "success"
            link.addClass("voted")
            link.find(".score").html(data.total)
    
    false


  @preconditions: ->
    $(".score-box").length > 0

$.hot Question