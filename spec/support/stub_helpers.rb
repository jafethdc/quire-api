module StubHelpers
  def stub_fetch_fb_profile(clazz, is_valid, extra_fields = {})
    if is_valid
      profile = {
        id: '115896442242452',
        name: 'Carol Aladffbijbaab Thurnberg',
        email: 'lragnuasqf_1482606515@tfbnw.net',
        picture: { data: { url: 'https://scontent.xx.fbcdn.net/v/t1.0-1/s100x100/10354686_10150004552801856_220367501106153455_n.jpg?oh=b607b68bceb725319743396142d0768d&oe=5A040E73' } }
      }.merge(extra_fields)
      allow_any_instance_of(clazz).to receive(:fetch_fb_profile).and_return(profile)
    else
      http_status = 400
      response_body = "{'error':{'message':'Invalid OAuth access token.','type':'OAuthException','code':190,'fbtrace_id':'E6J2Ni8jUCX'}}"
      # It is necessary to raise an instance of the error.
      allow_any_instance_of(clazz).to receive(:fetch_fb_profile).and_raise(Koala::Facebook::ClientError.new(http_status, response_body))
    end
  end
end