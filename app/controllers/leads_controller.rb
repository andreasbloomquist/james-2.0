class LeadsController < ApplicationController
  before_filter :redirect_broker

  def show
    @lead = Lead.find_by_response_url(params[:response_url])
    @broker = cookies[:broker_id]
    @property = Property.new
  end
end
