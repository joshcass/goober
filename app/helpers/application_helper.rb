module ApplicationHelper

  def button_class(user)
    user.available? ? "button" : "button secondary disabled"
  end

end
