source 'https://rubygems.org'

ruby '3.4.5'

gem 'rails', '~> 7.0'

# Persistence & cache

gem 'pg'
gem 'dalli'
gem 'que'

# Views

gem 'haml', '~> 5'  # haml 6 removed haml_tag; replacement unclear
gem 'haml-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'
gem 'formtastic'
gem 'jbuilder', '~> 2.0'

gem 'jquery-rails'
gem 'turbolinks'

# Static pages

gem 'high_voltage'
gem 'kramdown'

# Email

gem 'mail'
gem 'valid_email'
gem 'mailchimp-api', require: 'mailchimp'
gem 'net-smtp'

# Image uploads

gem 'carrierwave'
gem 'mini_magick'

# GitHub integration

gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
gem 'octokit'

# Calendar integration

gem 'icalendar'
gem 'icalendar-recurrence'

# Util

gem 'ransack'
gem 'ice_nine'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'spring'
  gem 'letter_opener'

  gem 'unicorn', platform: :ruby
  gem 'minitest-spec-rails'
  gem 'factory_bot_rails'
  gem 'ffaker', '< 2.17'

  gem 'rails_real_favicon'
end

group :production do
  gem 'exception_notification'
  # gem 'therubyracer'
end
