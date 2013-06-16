class Comment
  constructor: ->
    @_reveal_edit_links()
    @_bind_events()

  _bind_events: =>
    $(document).on "click", ".add-comment-link", @_show_comment_form    
    $(document).on "click", ".comment-form-wrap .close", @_remove_comment_form
    $(document).on "submit", ".comment-form.remote", @_submit_comment_form
    $(document).on "click", ".comment-vote-link", @_vote

  _show_comment_form: (e) =>
    link = $(e.currentTarget)
    answer_el = link.parents(".answer").first()
    
    $.get link.data("url"), (response) =>
      anchor = answer_el.find(".new-comment-anchor")
      
      if anchor.find(".comment-form-wrap").length == 0
        comment_form = $(response.html)
        anchor.append(comment_form)
        comment_form.hide().show("blind", {}, 800)
        answer_el.addClass("editing")
    
    false    

  _remove_comment_form: (e) =>
    link = $(e.currentTarget)
    answer_el = link.parents(".answer").first()

    link.parents(".comment-form-wrap").first().hide("blind", {}, 800, ->
      $(this).remove()
      answer_el.removeClass("editing")
    )
    false

  _submit_comment_form: (e) =>
    form = $(e.currentTarget)
    answer_el = form.parents(".answer").first()

    $.post form.attr("action"), form.serialize(), (response) =>
      if response.status == "err"
        form.parents(".new-comment-anchor").html(response.html)
      else
        form.parents(".new-comment-anchor").html("")
        comment_el = $(response.html)
        answer_el.find("ul.comments").append(comment_el)
        comment_el.addClass("editable")
        comment_el.effect("highlight", {}, 1000)
        answer_el.removeClass("editing")
    false

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
            link.parents("li.comment").first().find(".score").html(data.total)

    else
      # add vote
      $.ajax
        type: "POST"
        url: link.data("url")
        success: (data) =>
          if data.status == "success"
            link.addClass("voted")
            link.parents("li.comment").first().find(".score").html(data.total)   

    false    

  _reveal_edit_links: =>
    # read authorizations from cookie...
    auths = $.parseJSON($.cookie("page_authorizations"))

    for comment_id in auths.comment_ids
      $(".comment[data-id='#{comment_id}']").addClass("editable")

  @preconditions: =>
    $(".show-question").length > 0

$.hot Comment