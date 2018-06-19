module ApplicationHelper

  # Personalize title
  def title(page_title)
    content_for(:title) { page_title }
  end

  # Show error for models
  def show_errors(model)
    return if model.errors.empty?

    res = "<div class='error_explanation'>"+"<h4>#{pluralize(model.errors.count, "error")} prohibited this model from being saved:</h4><ul>"
    model.errors.full_messages.each do |msg|
      res += "<li>#{msg}</li>"
    end
    res += "</ul></div>"

    return res.html_safe
  end

  # Return a Time objects in milliseconds
  def time_in_milliseconds(time)
    (time.to_f * 1000).to_i
  end

end
