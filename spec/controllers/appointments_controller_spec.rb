require 'rails_helper'

RSpec.describe AppointmentsController, :type => :controller do
  
  describe "GET show" do
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET thank_you" do
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET add_user_cal" do
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET add_broker_cal" do
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end
end
