module StubHelpers
  def stub_validate_fb_user(clazz, is_valid, extra_fields={})
    if is_valid
      profile = {
          id: '115896442242452',
          name: 'Carol Aladffbijbaab Thurnberg',
          email: 'lragnuasqf_1482606515@tfbnw.net',
      }.merge(extra_fields)
      allow_any_instance_of(clazz).to receive(:validate_fb_user).and_return(profile)
    else
      http_status = 400
      response_body = "{'error':{'message':'Invalid OAuth access token.','type':'OAuthException','code':190,'fbtrace_id':'E6J2Ni8jUCX'}}"
      # It is necessary to raise an instance of the error.
      allow_any_instance_of(clazz).to receive(:validate_fb_user).and_raise(Koala::Facebook::ClientError.new(http_status, response_body))
    end
  end
end