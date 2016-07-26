class Filter
  def initialize(scope, params)
    @scope = scope
    @presenter = "#{@scope.model}Presenter".constantize
    @filters = params['q'] || {}
  end

  def filter
    return @scope unless @filters.any?
    @scope
  end

end