class TabbedForm
  constructor: ->
    @tab_bar = $("ul.nav-tabs")
    @tab_content = $(".tab-content")
    @section_input = $("input[name='section']")

    @_bind_events()


    if @section_input.val()? and @section_input.val() != ""
      window.location.hash = @section_input.val()
    else 
      @_preselect_section_from_url_hash_param()

  _bind_events: =>
    @_bind_hashchange_handler()
    @_bind_submit_handler()

  _bind_hashchange_handler: =>
    $(window).bind("hashchange", @_on_hash_change)

  _bind_submit_handler: =>
    $("form").submit (e) =>
      form = $(e.currentTarget)
      @section_input.val(window.location.hash)

      # because not necessarily in this form as there
      # are 4 in the document at this point
      form.append(@section_input)

  _on_hash_change: (e) =>
    @_preselect_section_from_url_hash_param()
    $(".alert").fadeOut(300)

  _preselect_section_from_url_hash_param: (opts) =>
    hash = window.location.hash

    if hash and hash != ""?
      hash_tab_link = $("a[href='#{hash}']")
      @tab_bar.find("li.active").removeClass("active")      
      hash_tab_link.parents("li").first().addClass("active")

      section = $(hash_tab_link.attr("href"))
      @tab_content.find(".tab-pane.active").removeClass("active")
      section.addClass("active")

  destroy: =>
    $(window).unbind('hashchange', @_on_hash_change)

  @preconditions: =>
    $(".tabbed-form").length > 0

$.hot TabbedForm