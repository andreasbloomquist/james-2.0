class WelcomeController < ApplicationController
   http_basic_authenticate_with name: "text", password: "james"

  def index
  end
end
