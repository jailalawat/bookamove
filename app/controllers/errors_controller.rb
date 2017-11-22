class ErrorsController < ApplicationController
  def file_not_found
  end

  def unprocessable
  end

  def internal_server_error
  end

  def unauthorized
    render(:layout => 'unauthorized', :status => 401)
  end
end
