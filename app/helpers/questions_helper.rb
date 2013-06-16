module QuestionsHelper
  def voted_on?(votable)
    current_user.try(:id) &&
      votable.votes.map(&:user_id).include?(current_user.id)
  end

  # Extracts the portion of the document that matches query text.
  # Consider refactoring into a complex activerecord
  # query leveraging "ts_headling". For present though
  # we will perform this with a regex (on the document, 
  # which is constructed at the query level - 
  # see app/models/concerns/questions/search.rb)
  def search_snippet(document, query, opts={})
    length = opts[:length] || 300

    start_padding = opts[:start_padding] || 30

    words = query.split(" ")
    
    text = original_text = document

    matcher = Regexp.new(Regexp.union(words).source, Regexp::IGNORECASE)

    if text.length > length
      first_keyword_occurrence = text =~ matcher

      if first_keyword_occurrence && first_keyword_occurrence > start_padding
        start_offset = first_keyword_occurrence - start_padding
      else
        start_offset = 0
      end

      truncated = text.slice(start_offset, text.length)

      text = truncated.slice(0, length)

      if text.length < length
        # pad beginning with existing text
        padding_length = length - text.length
        padding_text = original_text.slice(0, padding_length)
        text = "...#{padding_text}...#{text}..."
      else
        text = "...#{text}..."
      end
    end

    highlighted = text.gsub(matcher) { |match| "<strong class='match'>#{match}</strong>" }

    highlighted.html_safe
  end
end