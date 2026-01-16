class ApiDocsController < ApplicationController
  def index
    redirect_to "/api/swagger"
  end
end
