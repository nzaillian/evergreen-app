module UiHelper
  def horizontal_divider
    code = <<-eos
      <span class='horizontal-divider'>&#183;</span>
    eos
    code.html_safe
  end

  def formatted_date(date)
    if date > 3.days.ago
      time_ago_in_words(date) + " ago"
    else
      date.to_s(:short_ordinal)
    end
  end

  def delete_link(text, path, opts={})
    data_opts = {method: :delete}

    data_opts[:confirm] = opts.delete(:confirm)

    classes = "delete-link"

    if opts[:class].present?
      classes += " " + opts[:class]
    end

    link_to "<i class='icon-trash'></i>#{text}".html_safe, path, class: classes, data: data_opts
  end

  def uneditable_input_tag(val, label, opts={})
    classes = "uneditable-input"

    if opts[:class]
      classes += " " + opts[:class]
    end

    code = <<-eos
      <div class='input control-group'>
        <label class='control-label'>
          #{label}
        </label>
        <div class='controls'>
          <span class="#{classes}">#{val}</span>
        </div>
      </div>
    eos

    code.html_safe
  end


  def markdown(content)
    rendered = markdown_renderer.render(content)

    # hack around Redcarpet "<p>" tag content wrapping
    # (see https://github.com/vmg/redcarpet/issues/92)
    filtered = Regexp.new('^<p>(.*)<\/p>$').match(rendered)

    if filtered && filtered.length > 1
      filtered[1].html_safe
    else
      rendered.html_safe
    end
  end

  private

  def markdown_renderer
    unless defined?(@@redcarpet)
      render_options = {filter_html: true}

      html_renderer = Redcarpet::Render::HTML.new(render_options)

      @@markdown_renderer = Redcarpet::Markdown.new(html_renderer)
    end
    @@markdown_renderer
  end
end
