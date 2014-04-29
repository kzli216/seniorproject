module GoalsHelper
  def sti_goal_path(type = "goal", goal = nil, action = nil)
    Rails.logger.info "FIFOU #{format_sti(action, type, goal)}_path"
    send "#{format_sti(action, type, goal)}_path", goal
  end

  def format_sti(action, type, goal)
    action || goal ? "#{format_action(action)}#{type.underscore}" : "#{type.underscore.pluralize}"
  end

  def format_action(action)
    action ? "#{action}_" : ""
  end

  def convert_to_amcharts_json(data_array)
    data_array.to_json.gsub(/\"text\"/,"text").html_safe
  end
end