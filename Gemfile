source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'slim-rails'

# authenticate
gem 'devise'


# preloader
group :development, :test do
  gem 'spring'
end


# debug tools
group :development, :test do
  # pry
  gem 'pry-rails'          # rails cをpryに
  gem 'pry-doc'            # pryに show-doc(?), show-source($)コマンドを追加
  gem 'pry-byebug'         # binding.pry
  gem 'pry-stack_explorer' # pryにshow-stack等を追加

  # エラー画面系
  gem 'better_errors'
  gem 'binding_of_caller'

  # ActiveRecordの出力をテーブルに Hirb.disable/Hirb.enableで切り替えられる
  gem 'hirb'
  gem 'hirb-unicode'

  # print系
  gem 'awesome_print' # .apメソッド
  gem 'tapp' # .tappメソッドでオブジェクトの状態を出力

  # 出力制御系
  gem 'quiet_assets' # assetsファイルへのアクセスログを出力しない
end

# rspec
group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'spring-commands-rspec'

  # matchers
  gem 'shoulda-matchers'
  gem 'test_xml', '~> 0.1.7'

end

# group :production, :staging do
gem 'unicorn'
gem 'unicorn-worker-killer'
# end
