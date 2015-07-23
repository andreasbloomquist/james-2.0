class LeadsController < ApplicationController
  # http_basic_authenticate_with name: "text", password: "james"

  before_filter :redirect_broker

  def show
    @lead = Lead.find_by_response_url(params[:response_url])
    @broker = cookies[:broker_id]
    @broker_test = Broker.find(@broker)
    @property = Property.new
  end

  def thank_you
    @response_url = params[:resonse_url]
    render :thank_you
  end
end
