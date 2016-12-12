class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @is_default = options[:is_default]
  end

  def matches?(request)
    @is_default || request.headers['Accept'].include?("application/vnd.quire-api.v#{@version}")
  end
end