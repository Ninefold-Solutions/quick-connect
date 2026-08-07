module UrlHelper
  def absolute_url(path)
    return path if path.blank?

    if path.include?("https://") || path.include?("http://")
      path
    else
      path.prepend("https://")
    end
  end

  def account_script_name
    script_name = request&.script_name.to_s
    return script_name if script_name.present? && script_name != "/"

    account = Current.user&.account if Current.user.present?
    return "/#{account.id}" if account.present?

    nil
  end

  def account_url_options
    script_name = account_script_name
    return {} if script_name.blank?

    { script_name: script_name }
  end

  def default_url_options
    account_url_options
  end

  def account_root_path
    root_path(**account_url_options)
  end
end
