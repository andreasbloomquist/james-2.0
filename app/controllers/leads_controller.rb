class LeadsController < ApplicationController
  before_action :redirect_broker

  def show
    @lead = Lead.find_by_response_url(params[:response_url])
    @broker = Broker.find(cookies[:broker_id])
    @property = Property.new
    if @lead.user.is_inactive?
      flash[:error] = "TENANT IS NO LONGER ACTIVE"
    end
  end

  def thank_you
    @response_url = params[:resonse_url]
    render :thank_you
  end
end
