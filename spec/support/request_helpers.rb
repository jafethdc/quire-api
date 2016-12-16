module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module HeadersHelpers
    def api_authorization_header(token)
      request.headers['Authorization'] =  token
    end
  end
end