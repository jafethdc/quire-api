class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @is_default = options[:is_default]
  end

  def matches?(request)
    @is_default || request.headers['Accept'].include?("application/vnd.marketplace.v#{@version}")
  end
end