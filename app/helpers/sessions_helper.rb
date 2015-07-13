module SessionsHelper

  def login(admin)
    session[:id] = admin.id
    @current_admin = admin
  end

  def current_admin
    return false if session[:id] == nil
    @current_admin ||= Admin.find(session[:id])
  end

  def logged_in?
    if current_admin == false
      return false
    else
      return true
    end
  end

  def set_broker_cookie(broker)
    cookies[:broker_id] = {
      :value => broker,
      :expires => 1.month.from_now,
      }
  end

  def redirect_broker
    cookies[:lead] = params[:response_url]
    unless cookies[:broker_id]
      return redirect_to authenticate_broker_path
    end
  end

  def redirect_unauthenticated
    unless logged_in?
      flash[:alert] = "Sorry, you must be logged in to see this content"
      return redirect_to login_path
    end
  end
end
