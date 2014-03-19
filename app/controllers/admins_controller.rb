class AdminsController < ApplicationController
  before_filter :require_admin

  private
    def require_admin
      binding.pry
      unless current_user.admin?
        flash[:danger] = "You do not have access to that area"
        redirect_to home_path
      end
    end
end
