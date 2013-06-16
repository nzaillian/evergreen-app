module ApplicationHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def default_opt(name, &block)
    was_assigned, value = eval(
      "[ local_assigns.has_key?(:#{name}), local_assigns[:#{name}] ]",
      block.binding)
    if was_assigned
      value
    else
      yield
    end
  end

  def alerts(options={})
    render_to_string(:partial => "/common/alerts", locals: options).html_safe
  end

  def admin?
    @company && can?(:admin, @company)
  end

  def team_member?
    (current_user && @company && @company.team_members.map(&:user_id).include?(current_user.id)) || false
  end

  def site_public?
    @company && @company.site_public == true
  end

  def site_private?
    @company && ! @company.site_public
  end

  def question_owner?
    @question && (@question.user == current_user)
  end

  def render_errors(record)
    if record.errors.any?
      render_to_string(partial: "/common/errors", formats: [:html], locals: {record: record}).html_safe
    else
      ""
    end
  end  

  def render_asset(path)
    Evergreen::Application.assets.find_asset(path).to_s.html_safe
  end
end
