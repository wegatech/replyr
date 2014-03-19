source "https://rubygems.org"
gemspec path: '..'

gem "rails", '~> 3.2.16'
gem 'mailman', git: 'git://github.com/titanous/mailman'
gem 'email_reply_parser', git: 'git://github.com/rudirocks/email_reply_parser'