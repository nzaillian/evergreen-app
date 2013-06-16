class ShowQuestionPage
  constructor: ->
    @_reveal_edit_links()
  
  _reveal_edit_links: =>
    # read authorizations from cookie...
    auths = $.parseJSON($.cookie("page_authorizations"))

    for question_id in auths.question_ids
      $(".question[data-id='#{question_id}']").add(".show-question").addClass("editable")

  @preconditions: ->
    $(".show-question").length > 0

$.hot ShowQuestionPage