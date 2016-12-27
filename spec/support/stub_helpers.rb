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
      allow_any_instance_of(clazz).to receive(:validate_fb_user).and_raise(Koala::Facebook::ClientError)
    end
  end
end