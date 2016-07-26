class Paginator
  def initialize(scope, query_params, url)
    @query_params = query_params
    @page = @query_params['page'] || 1
    @per = @query_params['per'] || 10
    @scope = scope
    @url = url
  end

  def paginate
    @scope.page(@page).per(@per)
  end
end