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
    sanitized_number = params[:broker][:phone_number].gsub(/[^0-9]/, "")
    @number = "+1#{sanitized_number}"
    @broker = Broker.is_broker?(@number)

    if @broker
      @broker.set_auth_code
      respond_to do |format|
        format.js
      end
    else
      flash[:success] = "Sorry, we weren't able to find that number"
      redirect_to authenticate_broker_path
    end
  end

  def authorize_broker
    @broker = Broker.find_by_phone_number(params[:broker])
    p @broker
    p params[:authorization_code]

    if @broker.auth_code === params[:authorization_code].to_i
      set_broker_cookie(@broker.id)
      redirect_to respond_to_lead_path(cookies[:lead])
    else
      flash[:success] = "Sorry, that authorization code doesn't match our records."
      redirect_to authenticate_broker_path
    end
  end

  def logout
    @current_admin = session[:id] = nil
    flash[:success] = 'Successful login'
    redirect_to root_path
  end
end
