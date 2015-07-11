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
    if @broker.save
      flash[:success] = 'Broker was successfully added.'
      redirect_to brokers_path
    else
      flash[:error] = "#{@broker.errors.each {|e| e }}"
      redirect_to new_broker_path
    end
  end
  

  def edit
    @broker = Broker.find(params[:id])
  end


  def destroy
    @broker = Broker.find(params[:id])
    @broker.destroy
    flash[:success] = "Broker was succesfully deleted"
    redirect_to brokers_path
  end

  private

  def broker_params
    params.require(:broker).permit(:first_name, :last_name, :email, :company, :phone_number)
  end
end
