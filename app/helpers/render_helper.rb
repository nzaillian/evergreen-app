module RenderHelper
  def render_content(*args, &block)
    augmented_args = _normalize_args(*args, &block)

    augmented_args[:formats] = [:html]

    render_to_string(augmented_args).html_safe
  end
end