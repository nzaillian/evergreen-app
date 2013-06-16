class Vote
  constructor: ->
    @_reveal_edit_links()

  _reveal_edit_links: =>
    if $.cookie("page_authorizations")?
      # read authorizations from cookie...
      auths = $.parseJSON($.cookie("page_authorizations"))

      if auths.voted_on?
        for voted_on in auths.voted_on
          $(".vote[data-votable-id='#{voted_on.votable_id}'][data-votable-type='#{voted_on.votable_type}']").addClass("voted")

    votable_elements = $(".question, .answer, .comment")

    ids = []

    votable_elements.each ->
      ids.push($(this).data("id"))

    # in the case that this is a fully browser or proxy-cached page, 
    # we need to fetch the auths from the server
    $.get "/votes", {votable_ids: ids}, (response) ->
      if response.voted_on?
        for voted_on in response.voted_on
          $(".vote[data-votable-id='#{voted_on.votable_id}'][data-votable-type='#{voted_on.votable_type}']").addClass("voted")

  @preconditions: => true


$.hot Vote