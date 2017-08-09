# Quire API
This is the API for the [Quire android app](https://github.com/narenkukreja/quire). 

## Documentation
See the [Quire API documentation](http://jafethdiaz.me/quire-api-docs/#introduction)

## Set up
```
# Install dependencies
bundle install

# Make sure you have postgis installed
# Modify database, username and password in config/database.yml according to your needs

rake db:create
rake db:migrate

# Set the environment variables listed below
(optional) rake db:seed
```

## Environment variables
* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* S3_BUCKET_NAME
* AWS_REGION

* FB_APP_ID
* FB_SECRET

* SENDBIRD_API_TOKEN

## Test

```
  rspec spec/
```

## Contributing

### Issues

In any project it's likely that a few bugs will slip through the cracks, so it
helps greatly if people document any bugs they find to ensure that they get
fixed promptly.

You can view a list of known issues and feature requests using [the issue tracker](
https://github.com/narenkukreja/quire/issues). If you don't see your issue (or you
aren't sure) feel free to [submit it!](https://github.com/narenkukreja/quire/issues)

Where appropriate, a screenshot works wonders to help us see exactly what the
issue is. You can upload screenshots directly using the GitHub issue tracker or
by attaching a link (to Imgur, for example), whichever is easier for you.

### Code

If you are a developer and wish to contribute to the app please fork the project
and submit a pull request.

## Team

[![Naren Kukreja](https://avatars2.githubusercontent.com/u/10284862?v=3&s=144)](https://github.com/narenkukreja)  | 
[![Jafeth Díaz](https://avatars1.githubusercontent.com/u/7109853?v=3&s=144)](https://github.com/JafethDC)
---|---
[Naren Kukreja](https://github.com/narenkukreja) |[Jafeth Díaz](https://github.com/JafethDC)

## Licensing

Quire is licensed under the [MIT LICENSE.](LICENSE)

In addition to the terms set by the MIT LICENSE, I ask that if you use
any code from this repository that you send me a message to let me know.
