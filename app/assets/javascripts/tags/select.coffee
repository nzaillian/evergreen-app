class TagSelect
  constructor: ->
    @el = $("#tag-select")
    @controls = @el.find(".controls")
    @input_wrap = @el.find("#tag-search-wrap")
    @input = @el.find("input#tag-search")
    @tag_list = @el.find("#tag-box")

    @_key_interval = 200
    @_enqueued_searches = []
    @_position_input()

    @bind_events()

  bind_events: =>
    # don't allow submission on "enter" press within tag search input
    @input.keydown (e) => return false if e.which == 13
    
    @input.keyup(@_handle_keypress)
    $("body").on "click", ".dropdown-content .close", @_close_dropdown
    $("body").on "click", "#new-tag .submit", @_submit_new_tag
    $("body").on "click", ".dropdown-content .tag-search-results li a", @_handle_existing_tag_add
    $("body").on "click", "#tag-box .tag .remove", @_handle_remove_tag

  _handle_keypress: (e) =>
    val = @input.val()

    if val.length >= 1
    
      @_enqueued_searches.push(val)

      setTimeout( =>
        
        last = @_enqueued_searches[@_enqueued_searches.length - 1]
        if last and last == val
          @_search_tags(val)
          @_enqueued_searches = []

      , @_key_interval)

  _handle_remove_tag: (e) =>
    link = $(e.currentTarget)
    tag_element = link.parents(".tag").first()

    @_remove_tag(tag_element.data("id"))
    tag_element.remove()

    @_position_input()

    false

  _search_tags: (term) =>
    filters = {}

    filters.term = term

    filters.exclude = []

    $("#tag-ids input").each ->
      filters.exclude.push($(this).val())

    $.get @el.data("url"), {filters: filters}, (response) =>
      @controls.find(".dropdown-content").remove()
      @controls.append(response.html)
  
  _clear_tag_search_dropdown: =>
    @controls.find(".dropdown-content").remove()

  _close_dropdown: =>
    @controls.find(".dropdown-content").remove()

  _submit_new_tag: (e) =>
    form = $(e.currentTarget).parents("form").first()
    form.find(".submit").addClass("disabled").val("Creating...")

    $.post form.attr("action"), form.serialize(), (response) =>
      if response.status == "success"
        @_close_dropdown()
        @_add_tag(response.tag.id)
        @controls.find(".tags").append(response.html)
        @input.val("")
        @_position_input()
      else
        @controls.find(".dropdown-content").replaceWith(response.html)

    false

  _handle_existing_tag_add: (e) =>
    link = $(e.currentTarget)
    list_item = link.parents("li").first()

    tag_id = list_item.data("id")
    tag_name = list_item.data("name")

    tag = {id: tag_id, name: tag_name}

    @controls.find(".tags").append(@_render_tag(tag))

    @_add_tag(tag_id)

    @input.val("")

    @_position_input()    

    @_close_dropdown()

    false

  _add_tag: (tag_id) =>
    input = $("<input />", {
      type: "hidden",
      name: "question[tag_ids][]",
      value: "#{tag_id}"
    })
    $("#tag-ids").append(input)

  _remove_tag: (tag_id) =>
    input = $("#tag-ids input[name='question[tag_ids][]'][value='#{tag_id}']")
    input.remove()

  _position_input: =>
    offset = 4

    @input_wrap.css({
      left: @tag_list.outerWidth() + offset 
      width: @el.outerWidth() - @tag_list.outerWidth() - offset - 2
    })

  _render_tag: (tag) =>
    $.trim("
      <li class='tag' data-id='#{tag.id}'>
        <span class='name'>#{tag.name}</span>
        <a class='remove'> &times; </a>
      </li>
    ")

  @preconditions: =>
    $("#tag-select").length > 0

$.hot TagSelect