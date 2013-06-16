# global status code handlers
$.ajaxSetup
  error: (jq_xhr, exception) ->
    if jq_xhr.status == 418
      data = $.parseJSON(jq_xhr.responseText)
      window.location.href = data.redirect_uri