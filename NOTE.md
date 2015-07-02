# Rails アプリケーションの始め方の例

## MacにRubyをインストール

```
brew update
brew install rbenv ruby-build

echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
exec $SHELL -l

rbenv --version

# インストール可能なRubyの一覧
rbenv install --list

rbenv install -v 2.2.0
rbenv rehash

rbenv versions

# 全体で使うRubyのバージョンを固定
rbenv global 2.2.0
rbenv rehash

ruby -v
```

## bundlerをインストール
```
gem install bundler
rbenv rehash
```

## MacにMySQLをインストール
```
brew install mysql

# 最初の情報を見落としてもinfoコマンドで何回も閲覧できる
brew info mysql

mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp
mysql.server start

/usr/local/opt/mysql/bin/mysqladmin -u root password 'root'
/usr/local/opt/mysql/bin/mysql_secure_installation
```

## my.cnfの場所
- グローバル設定     /etc/my.cnf
- サーバ固有の設定   /usr/local/var/mysql/my.cnf
- ユーザー固有の設定 ~/.my.cnf


## アプリケーション開発事始め

```
gem 'rails'
```

```
bundle install --path=vendor/bundle
bundle exec rails new . -d mysql
```


## 毎回のbundle execが面倒な場合はdirenvが便利

```
go get github.com/zimbatm/direnv
echo 'eval "$(direnv hook zsh)"' >> ~/dotfiles/.zshrc
echo 'export PATH=$PWD/.bin:$PATH' > .envrc
exec $SHELL -l
direnv allow
```

## データベースのセットアップ
- database.yml

```
rake db:create
rake db:migrate
```

- db/schema.rb に最初のスキーマを書く

```
rake db:setup
```


# vimでRails開発に便利なgem

```
# termial
gem "tmuxinator"

# vim
gem "gem-ctags"
gem "gem-browse"

# reference
gem "refe2"
gem "bitclust-dev"
gem "bitclust-core"

# guard
gem 'guard'
gem 'guard-rspec'
gem 'guard-bundler'
gem 'terminal-notifier-guard'
gem 'spring'
gem 'spring-commands-rspec'
gem 'rb-fsevent'

# slim
gem 'html2slim'
```


# rails g いろいろ

```
rails g -h
rails g model -h
```

```
rails g model post --skip-migration --skip-fixture --no-test-framework
rails g controller posts index show post --no-test-framework
```


# twitter bootstrapを使う

ダウンロードしてvendorに配置

|ダウンロードファイル|配置先|
|:--|:--|
|dist/css/bootstrap.min.css|vendor/assets/stylesheets/.|
|dist/js/bootstrap.min.js|vendor/assets/javascripts/.|
|dist/fonts|vendor/assets/.|


app/assets/javascripts/application.js

```
//= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require_tree .
```

app/assets/stylesheets/application.css

```
*= require bootstrap.min
*= require_tree .
*= require_self
*/
```


# rspec ことはじめ

```
group :development, :test do
  gem 'rspec-rails', '~> 3.0'
end
```

```
rails g rspec:install
```


# CircieCIのバッジをREADMEに表示

- https://circleci.com/docs/status-badges
- API Token を生成
  - Project Settings > Permissions > API Permissions
  - Statusを選んでToken labelに`badge`などと入力
- https://circleci.com/gh/violetyk/rails-sample.svg?style=shield&circle-token=:circle-token
- README.md等に貼り付け
  - ![status](https://circleci.com/gh/violetyk/rails-sample.svg?style=shield&circle-token=:circle-token)


# CircleCIからSlackへ通知
- SlackのWeb画面のConfigureIntegrationsへ
- CircleCIを選んでAdd
- 流す部屋を選ぶ
- できあがったWebhookのURLをコピー
- CircleCIのProjectSettings > Notifications > Chat Notificationsに貼り付てSave


# CircleCIからDockerHubへ
- Project Settings > Tweaks > Environment Variablesで環境変数を入れておく
  - `DOCKER_EMAIL`
  - `DOCKER_USER`
  - `DOCKER_PASS`
- circle.ymlに記述


# Unicorn

## 導入
```
gem 'unicorn'
```

config/unicorn.rb が設定ファイル

- 参考
  - http://unicorn.bogomips.org/examples/unicorn.conf.rb
  - https://github.com/herokaijp/devcenter/wiki/Rails-unicorn


## 起動

- `-c` 設定ファイル
- `-D` デーモン化
- `-E` 環境変数

```
bundle exec unicorn -c config/unicorn.rb -D -E production
```

## Unicornの起動や停止をrakeタスクにする

```
rails g task unicorn
```

- lib/tasks/unicorn.rake

```
rake -T unicorn
```


# devise

- ユーザ登録やログイン周りの仕組みをひととおり提供してくれるRailsエンジン
- Rackの認証フレームワークであるWardenがベース
- 必要な機能だけ使えるモジュラー構造
  - DatabaseAthenticatable
    - ユーザがサインインするときに認証するためのパスワードをDBに暗号化して保存
    - POSTリクエストかBasic認証
  - TokenAuthenticatable
    - 認証用トークンでサインインする
    - クエリ文字列かBasic認証
  - Oauthable
    - OmniAuth(https://github.com/intridea/omniauth) のサポート
  - Confirmable
    - 確認のメールを送り、サインイン時に確認されたかどうか検査する
  - Recoverable
    - パスワードのリセット
  - Registerable
    - 登録フローでサインアップ
    - アカウントの編集、削除
  - Rememberable
    - Cookieを使ったログイン状態の保存
  - Trackable
    - ログイン回数、日時やIPアドレスなどのトラッキング
  - Timeoutable
    - 特定期間アクセスがなければセッションを期限切れにする
  - Validatable
    - emailとパスワードによるヴァリデーション
    - 独自のバリデーションも追加できる
  - Lockable
    - サインインを特定回数失敗したらアカウントロックする
    - 特定時間経過後、メールによりアカウントロック解除できる


## 導入

```
gem 'devise'
```

```
bundle exec rails g devise:install
      create  config/initializers/devise.rb
      create  config/locales/devise.en.yml
===============================================================================

Some setup you must do manually if you haven't yet:

  1. Ensure you have defined default url options in your environments files. Here
     is an example of default_url_options appropriate for a development environment
     in config/environments/development.rb:

       config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

     In production, :host should be set to the actual host of your application.

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root to: "home#index"

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

  4. If you are deploying on Heroku with Rails 3.2 only, you may want to set:

       config.assets.initialize_on_precompile = false

     On config/application.rb forcing your application to not access the DB
     or load models when precompiling your assets.

  5. You can copy Devise views (for customization) to your app by running:

       rails g devise:views

===============================================================================
```

- 上記全て確認しておく(特に1と2)
- deviseの機能をつけたいモデルクラス(UserやAdminなど)を指定する

```
bundle exec rails g devise User
      invoke  active_record
      create    db/migrate/20150702081456_devise_create_users.rb
      create    app/models/user.rb
      invoke    rspec
      create      spec/models/user_spec.rb
      insert    app/models/user.rb
       route  devise_for :users
```

- `models/user.rb`でつけたいモジュールを確認
- `db/migrate/nnnnnnnnnnnnnn_devise_create_users.rb`でつけたいモジュールカラムを追加
  - ヘルパーがある
    - t.database_authenticatable
    - t.confirmable
    - t.recoverable
    - t.rememberable
    - t.trackable
- `config/routes.rb`でルーティングを確認`devise_for :user`
- マイグレーションを実行

```
rake db:migrate
```

## 確認

ここまでやると一通り機能が提供される。  
たとえば、`http://localhost:3000/users/sign_up`にアクセスすると、ユーザ登録画面が動く。


```
> show-routes -G user
        new_user_session GET    /users/sign_in(.:format)       devise/sessions#new
            user_session POST   /users/sign_in(.:format)       devise/sessions#create
    destroy_user_session DELETE /users/sign_out(.:format)      devise/sessions#destroy
           user_password POST   /users/password(.:format)      devise/passwords#create
       new_user_password GET    /users/password/new(.:format)  devise/passwords#new
      edit_user_password GET    /users/password/edit(.:format) devise/passwords#edit
                         PATCH  /users/password(.:format)      devise/passwords#update
                         PUT    /users/password(.:format)      devise/passwords#update
cancel_user_registration GET    /users/cancel(.:format)        devise/registrations#cancel
       user_registration POST   /users(.:format)               devise/registrations#create
   new_user_registration GET    /users/sign_up(.:format)       devise/registrations#new
  edit_user_registration GET    /users/edit(.:format)          devise/registrations#edit
                         PATCH  /users(.:format)               devise/registrations#update
                         PUT    /users(.:format)               devise/registrations#update
                         DELETE /users(.:format)               devise/registrations#destroy
```

## 基本的なメソッド

以降の処理はログインが必要
```
authenticate_user!
```

ログインが必要なコントローラは`before_action`で設定する
```
before_action :authenticate_user!
```

ユーザがログインしているかどうか。userのところは指定したモデル名。
```
user_sined_in?
```

ログイン中のユーザ情報
```
current_user
```

ログイン中のユーザのセッション情報
```
user_session
```


## カスタマイズ

### ビューのカスタマイズ
ログインやユーザ登録画面をカスタマイズするには、オーバーライド用のビューを生成して書いていく。

```
$ bundle exec rails g devise:views users
      invoke  Devise::Generators::SharedViewsGenerator
      create    app/views/users/shared
      create    app/views/users/shared/_links.html.erb
      invoke  form_for
      create    app/views/users/confirmations
      create    app/views/users/confirmations/new.html.erb
      create    app/views/users/passwords
      create    app/views/users/passwords/edit.html.erb
      create    app/views/users/passwords/new.html.erb
      create    app/views/users/registrations
      create    app/views/users/registrations/edit.html.erb
      create    app/views/users/registrations/new.html.erb
      create    app/views/users/sessions
      create    app/views/users/sessions/new.html.erb
      create    app/views/users/unlocks
      create    app/views/users/unlocks/new.html.erb
      invoke  erb
      create    app/views/users/mailer
      create    app/views/users/mailer/confirmation_instructions.html.erb
      create    app/views/users/mailer/reset_password_instructions.html.erb
      create    app/views/users/mailer/unlock_instructions.html.erb
```

コピー用のビューを使う設定を`config/initializers/devise.rb`に書いて`rails s`

```ruby
config.scoped_views = true
```

### コントローラのカスタマイズ

カスタマイズ用コントローラをコピー生成して、必要な機能を足していく

```
$ bundle exec rails g devise:controllers users
      create  app/controllers/users/confirmations_controller.rb
      create  app/controllers/users/passwords_controller.rb
      create  app/controllers/users/registrations_controller.rb
      create  app/controllers/users/sessions_controller.rb
      create  app/controllers/users/unlocks_controller.rb
      create  app/controllers/users/omniauth_callbacks_controller.rb
===============================================================================

Some setup you must do manually if you haven't yet:

  Ensure you have overridden routes for generated controllers in your route.rb.
  For example:

    Rails.application.routes.draw do
      devise_for :users, controllers: {
        sessions: 'users/sessions'
      }
    end

===============================================================================
```

ルーティングに、このコントローラを使うように設定。下記の場合はsessionsとregistrationsはカスタマイズしたコントローラを使う。

```ruby
devise_for :users, controllers: {
  sessions:       'users/sessions',
  registrations:  'users/registrations'
}
```




