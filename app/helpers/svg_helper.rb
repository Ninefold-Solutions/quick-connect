module SvgHelper
  def svg_icon(name, class_name: nil)
    file_path = Rails.root.join("app/assets/images/icons/#{name}.svg")
    return "".html_safe unless File.exist?(file_path)

    svg = File.read(file_path)
    default_class = "w-4 h-4 text-gray-800"
    combined_class = class_name.present? ? "#{class_name}" : default_class

    escaped_class = ERB::Util.html_escape(combined_class)

    if svg.match?(/class="[^"]*"/)
      svg.sub(/class="([^"]*)"/) { %(class="#{$1} #{escaped_class}") }.html_safe
    else
      svg.sub("<svg", %(<svg class="#{escaped_class}")).html_safe
    end
  end

  def action_svg_icon(name, class_name: "w-4 h-4 text-primary-600")
    svg_icon(name, class_name: class_name)
  end

  def info_icon(class_name: "w-4 h-4 text-gray-400")
    svg_icon("info-circle", class_name: class_name)
  end
end
