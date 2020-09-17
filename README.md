# OmniAuth Withings OAuth2 Strategy

[![Build Status](https://travis-ci.org/bartimaeus/omniauth-withings-oauth2.svg?branch=master)](https://travis-ci.org/bartimaeus/omniauth-withings-oauth2)
[![Gem Version](https://badge.fury.io/rb/omniauth-withings-oauth2.svg)](https://badge.fury.io/rb/omniauth-withings-oauth2)

A Withings OAuth2 strategy for OmniAuth.

For more details, read the Withings documentation: https://developer.withings.com/oauth2

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-withings-oauth2'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-withings-oauth2

## Usage

Register your application with withings to receive an API credentials: https://account.withings.com/partner/add_oauth2

This is an example that you might put into a Rails initializer at `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :withings, ENV['WITHINGS_CLIENT_ID'], ENV['WITHINGS_CLIENT_SECRET'], :scope => 'user.info,user.metrics,user.activity'
end
```

You can now access the OmniAuth withings OAuth2 URL: `/auth/withings`.

## Granting Member Permissions to Your Application

With the withings API, you have the ability to specify which permissions you want users to grant your application.
For more details, read the withings documentation: http://developer.withings.com/oauth2/#tag/scopes

You can configure the scope option:

```ruby
provider :withings, ENV['WITHINGS_CLIENT_ID'], ENV['WITHINGS_CLIENT_SECRET'], :scope => 'user.info user.metrics users.activity'
```

## Contributing

1.  Fork it
2.  Create your feature branch (`git checkout -b features/my-feature`)
3.  Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin features/my-feature`)
5.  Create new Pull Request
