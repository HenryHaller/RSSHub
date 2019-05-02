source "https://rubygems.org"
ruby "2.6.0"
gem 'rails', '~> 6.0.0.beta1'
gem 'webpush'


gem 'sendgrid-actionmailer'

gem 'rack-cors', require: 'rack/cors'

gem 'bootsnap', '>= 1.1.0', require: false
# gem "devise"
# gem 'responders', git: 'https://github.com/plataformatec/responders'

# gem 'vanilla-ujs' # vanilla javascript replacement for jquery ujs
gem 'faker', git: 'https://github.com/stympy/faker.git', branch: 'master'


gem "jbuilder", "~> 2.0"
gem 'pg', '>= 0.18', '< 2.0'
gem "puma"
gem "redis"

gem "bcrypt"

gem 'jwt'

# gem "autoprefixer-rails"
gem 'sassc-rails'
# gem "simple_form"
gem "uglifier"
gem 'webpacker', '>= 4.0.0.rc.3'
# gem "jquery-rails" # Add this line if you use Rails 5.1 or higher

# gem "csv"

gem "active_model_serializers", "~> 0.10.0"

gem "http"
gem "nokogiri"

# gem "interactor", "~> 3.0"
# gem "interactor-rails", "~> 2.0", git: "https://github.com/HenryHaller/interactor-rails"

gem "authtrail"
gem "maxminddb" # some kind of lightweight geocoder
gem "rubocop", "~> 0.61.1", require: false

gem 'feedjira' # hopefully tihs is a better feed parser than stdlib

gem 'kaminari'

group :development do
  gem "web-console", ">= 3.3.0"
end

group :development, :test do
  gem "dotenv"
  gem "pry-byebug"
  gem "pry-rails"
  gem "listen", "~> 3.0.5"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "dotenv-rails"
  gem "capybara"
  gem "selenium-webdriver"
  gem "chromedriver-helper"
  gem "launchy"
  gem 'factory_bot_rails'
end

group :test do
  gem 'rspec-rails', '~> 3.8'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'database_cleaner'
end
