$ready ->
  $(".radio-button-group").each ->
    group = $(this)
    buttons = group.find(".btn")
    form = group.parents("form").first()

    group.find(".btn.active").removeClass("active")
    checked = group.find("input[type='radio']:checked")
    checked.parents(".btn").first().addClass("active")


    form.submit (e) ->
      # deselect any selected radios
      group.find("input[type='radio']:checked").prop("checked", false)

      selected = group.find(".btn.active")
      radio = selected.find("input[type='radio']")

      # select the radio in the active button
      radio.prop('checked', true)
