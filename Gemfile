source 'http://rubygems.org'
ruby "2.0.0"

gem 'rails', '3.2.13.rc2'
gem "haml"

gem 'formtastic', github: 'justinfrench/formtastic', branch: '2.1-stable'
gem 'formtastic-bootstrap', github: 'cgunther/formtastic-bootstrap', branch: 'bootstrap2-rails3-2-formtastic-2-1'

gem "thin"

gem "mongoid", '~> 3.0.0'
gem 'mongoid-history'

#gem 'will_paginate', '>=3.0.pre'
gem 'acts-as-taggable-on'

gem "jquery-rails"

# for pagination https://github.com/amatsuda/kaminari
gem 'kaminari'

# for access control
gem 'cancan' 

# for user registration and authentication
gem 'devise'
#gem 'devise_rpx_connectable'

# for text-to-html formatting
gem 'RedCloth'

group :production do
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl'
  gem 'database_cleaner'

#  gem 'capybara'

#  gem 'cucumber-rails'
#  gem 'cucumber'
#  gem 'rspec-rails'
#  gem 'spork'
#  gem 'launchy'    # So you can do Then show me the page
#  gem 'rails3-generators'

#  gem 'factory_girl_rails'  
#  gem 'mongoid-rspec'
# 
#  gem 'rb-inotify'
#  gem 'libnotify'
#  gem 'guard-rspec'    # To run the tests continuously
end

group :assets do
  gem 'yui-compressor'
  gem 'execjs'
end

group :development, :test do
  gem 'therubyracer'
end

gem 'mongoid_search'


# ======
# The other original references in the file
# ======

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
