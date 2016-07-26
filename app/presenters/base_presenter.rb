class BasePresenter

  @relations = []
  @sort_attributes = []
  @filter_attributes = []
  @build_attributes = []

  class << self
    attr_accessor :relations,
                  :sort_attributes,
                  :filter_attributes,
                  :build_attributes

    def related_to(*args)
      @relations = args.map(&:to_s)
    end

    def sort_by(*args)
      @sort_attributes = args.map(&:to_s)
    end

    def filter_by(*args)
      @filter_attributes = args.map(&:to_s)
    end

    def build_with(*args)
      @build_attributes = args.map(&:to_s)
    end
  end

  attr_accessor :object, :params, :data

  def initialize(object, params, options = {})
    @object = object
    @params = params
    @options = options
    @data = HashWithIndifferentAccess.new
  end

  def as_json(*)
    @data
  end

end