source 'https://rubygems.org'


gem 'rails', '5.0.0.beta3'
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

gem 'high_voltage', github: 'thoughtbot/high_voltage'
gem 'kramdown'

gem 'activeadmin', github: 'gregbell/active_admin'
gem 'bcrypt'
gem 'omniauth-github'

gem 'carrierwave'
gem 'mini_magick'

gem 'delayed_job_active_record'

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

  gem 'rails_real_favicon'
end

group :production do
  gem 'exception_notification', git: 'git://github.com/pcantrell/exception_notification'
  gem 'therubyracer'
end
