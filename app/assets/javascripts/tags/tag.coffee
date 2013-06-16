$ ->  
  # for tags that are li tags and not a tags
  # (for reasons of styling), proxy clicks to
  # the contained a tag.
  $(document).on "click", "ul.tags.clickable li.tag", (e) ->    
    tag = $(e.currentTarget)    
    
    if tag.find("a").length > 0
      window.location = tag.find("a").attr("href")
      