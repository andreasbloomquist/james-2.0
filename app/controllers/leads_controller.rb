class LeadsController < ApplicationController
  before_filter :redirect_broker

  def show
    @lead = Lead.find_by_response_url(params[:response_url])
    @broker = cookies[:broker_id]
    @property = Property.new
  end

  def thank_you
    @response_url = params[:resonse_url]
    render :thank_you
  end
end
