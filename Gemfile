source 'https://rubygems.org'
git_source(:github) { |name| "https://github.com/#{name}.git" }

gem 'rails', '~> 5.0'

# Persistence & cache

gem 'pg', '~> 0.2'
gem 'dalli'
gem 'que'

# Views

gem 'haml', github: 'haml/haml'
gem 'haml-rails', github: 'indirect/haml-rails', tag: 'v1.0.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'
gem 'formtastic'
gem 'jbuilder', '~> 2.0'

gem 'jquery-rails'
gem 'turbolinks', '~> 5.0'

# Static pages

gem 'high_voltage', github: 'thoughtbot/high_voltage'
gem 'kramdown'

# Email

gem 'mail'
gem 'valid_email'
gem 'mailchimp-api', require: 'mailchimp'

# Image uploads

gem 'carrierwave'
gem 'mini_magick'

# GitHub integration

gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection', '~> 0.1'  # https://github.com/omniauth/omniauth/wiki/Resolving-CVE-2015-9284
gem 'octokit'

# Calendar integration

gem 'icalendar'
gem 'icalendar-recurrence'

# Util

gem 'ransack', github: 'activerecord-hackery/ransack'
gem 'ice_nine'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'

  gem 'spring'
  gem 'letter_opener'

  gem 'unicorn', platform: :ruby
  gem 'minitest-spec-rails'
  gem 'factory_girl_rails'
  gem 'ffaker', '< 2.17'

  gem 'rails_real_favicon'
end

group :production do
  gem 'exception_notification'
  gem 'therubyracer'
end
