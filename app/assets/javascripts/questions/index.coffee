class QuestionsIndex
  constructor: ->
    @set_avatar_wrapper_height()

  # unfortunate hack: we want user avatars to be
  # vertically aligned in their containing rows
  # but these have dynamic height. We're using the 
  # "display: table" trick but still need to set an
  # explicit height on the outermost div.
  set_avatar_wrapper_height: =>
    $("ul.questions-list li.question .avatar-wrap").each ->
      avatar_wrap = $(this)
      containing_row = avatar_wrap.parents(".row").first()

      avatar_wrap.height( containing_row.height() )

  @preconditions: => $(".questions-index").length > 0


$.hot QuestionsIndex