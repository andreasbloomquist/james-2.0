class SessionsController < ApplicationController
  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.confirm(params.require(:admin).permit(:email, :password))
    if @admin
      login(@admin)
      flash[:success] = 'Successful login'
      redirect_to admin_path
    else
      flash[:error] = 'Invalid email address or password. Please try again.'
      redirect_to login_path
    end
  end

  def authenticate_broker
    @broker = Broker.new
  end

  def check_broker
    @number = "+1#{params[:broker][:phone_number]}"
    @broker = Broker.is_broker?(@number)
    if @broker
      set_broker_cookie(@broker.id)
      redirect_to respond_to_lead_path(cookies[:lead])
    else
      flash[:success] = "Sorry, we weren't able to find that number"
      redirect_to authenticate_broker_path
    end
  end

  def logout
    @current_admin = session[:id] = nil
    flash[:success] = 'Successful login'
    redirect_to root_path
  end
end
