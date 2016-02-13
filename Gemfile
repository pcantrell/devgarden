source 'https://rubygems.org'


gem 'rails', '4.2.0'
gem 'pg'
gem 'haml-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'formtastic', ">= 2.3.0.rc2"
gem 'mail'
gem 'valid_email'
gem 'ice_nine'
gem 'dalli'

gem 'jquery-cdn', '~> 2.2.0'
gem 'jquery-rails'
gem 'turbolinks'

gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'activeadmin', github: 'gregbell/active_admin'
gem 'devise', '>= 3.2.0'
gem 'bcrypt', '~> 3.1.7'

gem 'carrierwave'
gem 'mini_magick'

gem 'delayed_job_active_record'

# gem 'unicorn'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'spring'
  gem 'letter_opener'

  gem 'unicorn', platform: :ruby
  gem 'minitest-spec-rails'
  gem 'factory_girl_rails'
  gem 'ffaker'
end

group :production do
  gem 'exception_notification', git: 'git://github.com/pcantrell/exception_notification'
  gem 'therubyracer'
end
