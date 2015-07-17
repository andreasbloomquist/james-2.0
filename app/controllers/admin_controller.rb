class AdminController < ApplicationController
  # http_basic_authenticate_with name: "text", password: "james"

	before_filter :redirect_unauthenticated
  def index
	end

	private
		def set_admin
			@admin = Admin.find(session[:id])
    end
end
