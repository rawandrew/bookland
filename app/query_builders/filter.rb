class Filter
  def initialize(scope, params)
    @scope = scope
    @presenter = "#{@scope.model}Presenter".constantize
    @filters = params['q'] || {}
  end

  def filter
    return @scope unless @filters.any?
    @filters = format_filters
    build_filter_scope
    @scope
  end

  private

  def format_filters
    @filters.each_with_object({}) do |(key, value), hash|
      hash[key] = {
          value: value,
          column: key.split('_')[0...-1].join('_'),
          predicate: key.split('_').last
      }
    end
  end

  def build_filter_scope
    @filters.each do |key, data|
      @scope = send(data[:predicate], data[:column], data[:value])
    end
  end

  def eq(column, value)
    @scope.where(column => value)
  end
  def cont(column, value)
    @scope.where("#{column} LIKE ?", "%#{value}%")
  end
  def notcont(column, value)
    @scope.where("#{column} NOT LIKE ?", "%#{value}%")
  end
  def start(column, value)
    @scope.where("#{column} LIKE ?", "#{value}%")
  end
  def end(column, value)
    @scope.where("#{column} LIKE ?", "%#{value}")
  end
  def gt(column, value)
    @scope.where("#{column} > ?", value)
  end
  def lt(column, value)
    @scope.where("#{column} < ?", value)
  end

end