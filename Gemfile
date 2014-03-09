source 'https://rubygems.org'
ruby '2.0.0'

gem 'jquery-rails'
gem 'sidekiq'
gem 'bootstrap-sass'
gem 'coffee-rails'
gem "rails", "4.0.1"
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
# gem 'bootstrap_form'
gem 'bootstrap_form', :git => 'https://github.com/bootstrap-ruby/rails-bootstrap-forms.git', :ref => '2c67704174943fc5526dbad44b184e26ac5d4f07'

gem 'bcrypt-ruby'
gem 'fabrication'
gem 'faker'
gem "better_errors"
gem 'foreman'
gem 'unicorn'
gem 'carrierwave'
gem 'fog'
gem 'mini_magick'
gem 'figaro'
gem 'stripe'
gem 'stripe_event'

group :development do
  gem 'sqlite3'
  # gem 'thin'
  gem "binding_of_caller"
  gem 'meta_request'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'pry'
  gem 'pry-nav'
  gem 'spring-commands-rspec'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'guard-bundler'
  gem 'guard-haml'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'letter_opener'
  gem 'capybara-email'

  gem 'spork-rails', '4.0.0'
  gem 'guard-spork', '1.5.0'
  # gem 'childprocess', '0.3.6'

  # gem 'figaro'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

