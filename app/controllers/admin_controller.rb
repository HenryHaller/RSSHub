class AdminController < ApplicationController
  def panel
    if current_user.role == "admin"

    else
      redirect_back fallback_location: root_path
    end
  end
end
