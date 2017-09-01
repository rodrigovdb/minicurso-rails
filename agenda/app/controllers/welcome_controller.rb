class WelcomeController < ApplicationController
  def index
    @name = params[:name]
  end
end
