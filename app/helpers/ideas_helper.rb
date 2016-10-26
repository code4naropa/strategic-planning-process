module IdeasHelper

  def write_idea_action idea

    # render form
    if @current_user && @current_user.confirmed_registration
      render :partial => "ideas/form", locals: {idea: idea}

    # render confirmation reminder
    elsif @current_user
      render :partial => "shared/notice",
        locals: {
          notice: {
            :path => confirmation_reminder_registration_path,
            :icon => "email",
            :text => "Please confirm your email address to create a new idea."
          }
        }

    # render log in notice
    else
      render :partial => "shared/notice",
        locals: {
          notice: {
            :path => login_path,
            :icon => "vpn_key",
            :text => "Please log in or sign up to create a new idea."
          }
        }

    end
  end

end
