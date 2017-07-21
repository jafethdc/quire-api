module ImagesHelpers
  def self.url_to_base64(url)
    response = open(url)
    file_type = response.meta['content-type']
    b64 = Base64.strict_encode64(response.read)
    "data:#{file_type};base64,#{b64}"
  end
end