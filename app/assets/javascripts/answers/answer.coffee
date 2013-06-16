class Answer
  constructor: ->
    @_reveal_edit_links()
    @_bind_events()

  _bind_events: =>
    $(document).on "click", ".vote-link", @_vote

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
            link.parents("li.answer").first().find(".answer-score").html(data.total)

    else
      # add vote
      $.ajax
        type: "POST"
        url: link.data("url")
        success: (data) =>
          if data.status == "success"
            link.addClass("voted")
            link.parents("li.answer").first().find(".answer-score").html(data.total)   

    false
  
  _reveal_edit_links: =>
    # read authorizations from cookie...
    auths = $.parseJSON($.cookie("page_authorizations"))

    for answer_id in auths.answer_ids
      $(".answer[data-id='#{answer_id}']").addClass("editable")

  destroy: =>
    $('body').off("click", ".vote-link", @_vote)

  @preconditions: ->
    $(".show-question").length > 0    

$.hot Answer