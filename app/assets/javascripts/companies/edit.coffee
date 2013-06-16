class Edit
  constructor: ->
    @tab_bar = $("ul.nav-tabs")
    @tab_content = $(".tab-content")
    @section_input = $("input[name='section']")

    @_bind_events()


    if @section_input.val()? and @section_input.val() != ""
      window.location.hash = @section_input.val()
    else 
      @_preselect_section_from_url_hash_param()

    @_init_codemirror()
    @_init_links_sortable()

  _bind_events: =>
    @_bind_hashchange_handler()
    @_bind_submit_handler()

  _init_codemirror: =>
    styles_input = $("#styles-input")
    
    if styles_input.is(":visible") and ! styles_input.hasClass("has-codemirror")    
      @styles_codemirror = CodeMirror.fromTextArea(styles_input.get(0), {
        theme: "eclipse",
        tabSize: 2
      })
      styles_input.addClass("has-codemirror")


  _table_sort_helper: (e, ui) ->
    ui.children().each ->
      $(this).width($(this).width())

    return ui

  _update_sort_positions: =>
    links_table = $("#links-table")
    links = []

    counter = 1
    
    links_table.find("tbody tr").each ->
      
      links.push({
        id: $(this).data("id")
        position: counter
      })

      counter++

    $.ajax
      type: "PATCH"
      url: links_table.data("updateUrl")
      data: {links: links}




  _init_links_sortable: =>
    links_table = $("#links-table")

    if links_table.is(":visible") and ! links_table.find("tbody").hasClass("ui-sortable")
      links_table.find("tbody").sortable({
        helper: @_table_sort_helper
        update: (e, ui) =>
          ui.item.effect("highlight", {}, 1000)
          @_update_sort_positions()       
      }).disableSelection()

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
    @_init_codemirror()
    @_init_links_sortable()
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
    @styles_codemirror = null

$ready ->
  window._company_page_edit.destroy if window._company_page_edit?
  window._company_page_edit = new Edit() if $("#edit-company").length > 0