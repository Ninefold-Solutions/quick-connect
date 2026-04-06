module ApplicationHelper
  include IconHelper
  include ButtonHelper
  include DateHelper

  def tailwind_form_with(**options, &block)
    form_with(**options.merge(builder: TailwindFormBuilder), &block)
  end

  def display_image(resource)
    if resource.last_name
      resource.first_name[0, 1].upcase_first + resource.last_name[0, 1].upcase_first
    else
      resource.first_name[0]
    end
  end

  def goal_path(goal)
    if goal.goalable_type == "Project"
      project_milestones_path(goal.goalable)
    else
      employee_goals_path(goal.goalable)
    end
  end

  def login_options
    @redirect_path ? { redirect_to: @redirect_path } : {}
  end

  def ensure_protocol(url)
    if url[/\A(http|https):\/\//i]
      url
    else
      "http://" + url
    end
  end

end
