class ApplicationController < ActionController::API

  protected

  def paginate(scope)
    paginator = Paginator.new(scope, request.query_parameters, current_url)
    response.headers['Link'] = paginator.links
    paginator.paginate
  end

  def current_url
    request.base_url + request.path
  end
end
