class AdminController < ApplicationController
  before_action :redirect_unauthenticated
  def index
  end

  private

    def set_admin
      @admin = Admin.find(session[:id])
    end
end
