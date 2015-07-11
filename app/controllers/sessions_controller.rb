class SessionsController < ApplicationController

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.confirm(params.require(:admin).permit(:email, :password))
    if @admin
      login(@admin)
      flash[:success] = "Successful login"
      redirect_to admin_path
    else
      flash[:error] = "Invalid email address or password.  Please try again."
      redirect_to login_path
    end
  end

  def logout
  	@current_admin = session[:id] = nil
		flash[:success] = "Successful login"
		redirect_to root_path
  end
end
