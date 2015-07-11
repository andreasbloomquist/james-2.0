class BrokersController < ApplicationController
  before_filter :redirect_unauthenticated
  
  def index
    @brokers = Broker.all
  end

  def new
    @broker = Broker.new
  end

  def create
    @broker = Broker.new(broker_params)

    respond_to do |format|
      if @broker.save
        redirect_to admin_path, success: 'Broker was successfully added.'
      else
        format.html { redirect_to new_broker_path alert: @store.errors }
      end
    end
  end

  def destroy
  end

  private

  def broker_params
    params.require(:broker).permit(:first_name, :last_name, :email, :company)
  end
end
