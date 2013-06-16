class AnswerForms
  constructor: ->
    $(document).on "submit", ".answer-form.remote", @_post_answer

  _post_answer: (e) =>
    form = $(e.currentTarget)
    
    $.ajax
      type: (form.find("_method").val() if form.find("_method").length > 0) || "POST"
      url: form.attr("action")
      data: form.serialize()      
      success: (data, text_status, jq_xhr) =>
        debugger
        if data.status == "success"
          $(".answer-form-wrap").replaceWith( $(data.new_form) )
          $(".answers-list-wrap").removeClass("empty")
          $answer_el = $(data.partial)
          $("ul.answers").append( $answer_el )
          $answer_el.addClass("editable")
          $answer_el.effect("highlight", {color: "#dff0d8"}, 3000)
        else
          $(".answer-form-wrap").replaceWith( $(data.form) )

    false

$(document).ready ->
  new AnswerForms