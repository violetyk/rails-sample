# rails-sample
Ruby on Rails アプリケーションサンプル

![status](https://circleci.com/gh/violetyk/rails-sample.svg?style=shield&circle-token=cc70abd67d48d7fd160e642b7e0029957b6919ec)

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


# fluentd

- Macにdmgでインストール
  - http://docs.fluentd.org/articles/install-by-dmg
- 起動と停止
  - sudo launchctl load /Library/LaunchDaemons/td-agent.plist
  - sudo launchctl unload /Library/LaunchDaemons/td-agent.plist
- 設定ファイル
  - /etc/td-agent/td-agent.conf
  - /etc/td-agent/plugin
- ログファイル
  - /var/log/td-agent/td-agent.log


# Docker

## Boot2Docker

- ローカルのMacにインストールして起動
- https://github.com/boot2docker/osx-installer/releases/latest

```
which docker
which boot2docker
boot2docker init
boot2docker start
eval "$(boot2docker shellinit)"
boot2docker status
```

VMにログイン
```
boot2docker ssh
```

停止
```
boot2docker stop
```

## はじめてのDocker

### Hello worldコンテナを起動

- Docker Hubからubuntu:14:04のイメージを持ってくる
- `run`でイメージからコンテナを作成＆起動する
- `/bin/echo "HelloWorld"`

```
docker run ubuntu:14.04 /bin/echo 'Hello world'
docker images
```


### インタラクティブコンテナ

- コンテナを起動して`/bin/bash`を動かす
  - `-t`  Allocate a pseudo-TTY
  - `-i`  Keep STDIN open even if not attached
- `exit`してプロセス終了するとコンテナもストップ

```
docker run -t -i ubuntu:14.04 /bin/bash
```

### daemon版 Hello world

- バックグラウンドで実行
  - `-d, --detach=false` Run container in background and print container ID
- NAMEをつけないと適当な名前が割り振られる
- 起動中のコンテナをみるには`docker ps`
- コンテナの出力をみるには`docker logs`でみる
- コンテナの停止は`docker stop`

```sh
docker run -d ubuntu:14.04 /bin/sh -c "while true; do echo hello world; sleep 1; done"
50a5fef8eddc736d74678243179789062025f7c6d65a8d67a3c2335429786e7c

# の文字列はコンテナID。起動中のコンテナを調べると出てくる
docker ps
CONTAINER ID  IMAGE         COMMAND                CREATED        STATUS        PORTS     NAMES
50a5fef8eddc  ubuntu:14.04  "/bin/sh -c 'while t   4 seconds ago  Up 3 seconds            jovial_banach
```

```sh
# コンテナの出力をみる
docker logs jovial_banach
docker logs 50a5fef8eddc
```


## Dockerコマンドまとめ

### コンテナの操作
```sh
# 作成と起動
docker run ubuntu:14.04 /bin/echo 'Hello world'
docker run --name hello_world ubuntu:14.04 /bin/echo 'Hello world'
docker run -t -i ubuntu:14.04 /bin/bash
docker run -d ubuntu:14.04 /bin/sh -c "while true; do echo hello world; sleep 1; done"

# --rm 終了時にdockerコンテナを削除する
docker run --rm -t -i ubuntu /bin/bash

# -d バックグラウンドで起動
docker run -d ubuntu:14.04 /bin/echo 'Hello world'

# host側のディレクトリをコンテナのディレクトリにマウント
docker run -v /host/volume:/var/volume:rw ubuntu:14.04

# 起動中のコンテナを表示
docker ps

# コンテナの出力をみる
docker logs jovial_banach
docker logs 50a5fef8eddc

# コンテナ停止
docker stop CONTAINER_ID

# 全コンテナを表示
docker ps -a

# コンテナのIDだけの一覧を表示
docker ps -q

# 停止中も含むコンテナの中で最後に作成したものだけを表示
docker ps -l

# コンテナの起動
docker start CONTAINER_ID

# 起動中のコンテナにプロセスを追加
docker exec 370cbfea2519 env
docker exec -i -t 370cbfea2519 /bin/bash

# コンテナの強制終了
docker kill CONTAINER_ID

# 全コンテナ削除
docker -a -q | xargs docker rm
```

### イメージの操作

```sh
# 一覧
docker images

# 削除
docker rmi IMAGE_ID
# タグなしのイメージを強制削除
docker rmi -f  $(docker images | grep '\<none\>' | awk '{print $3}')


# カレントディレクトリにあるDockerfileからイメージを作成
docker build ./
docker build -t REPOSITORY:TAG ./
# キャッシュを使わないでビルド
docker build --no-cache .
```



# Dockerfile

- WEBrickのコンテナをつくってみる

```test.rb
require 'webrick'

# Dockerコンテナ内ではフォアに持ってこないとダメ
# Process.daemon
WEBrick::HTTPServer.new(DocumentRoot: './', Port: 3000).start
```

```Dockerfile
FROM ruby:2.2.0
MAINTAINER violetyk <yuhei.kagaya@gmail.com>

ENV APP_HOME /app
RUN mkdir $APP_HOME

COPY ./test.rb ${APP_HOME}/
WORKDIR $APP_HOME
EXPOSE 3000
# CMD "ruby test.rb && tail -f /dev/null"
CMD ["ruby", "test.rb"]
```

- イメージをビルド
```sh
docker build -t sample .
docker images
```

- VMのIPを確認しておく
- VMの3000番とコンテナの30000番をつなぎ、コンテナを作成して起動
- `192.168.59.103:3000`へアクセスするとコンテナが動く

```
boot2docker ip
192.168.59.103

docker run -d -p 3000:3000 be730d27704f
```

## CMDとENTRYPOINT
- https://www.qoosky.net/references/207/ より

`CMD` は `ENTRYPOINT` の引数を指定します。`ENTRYPOINT` の既定値は [""] です。  
`ENTRYPOINT` を変更しない場合、コンテナ内では `start` または `exec` 時に
```
CMD top -b
-> /bin/sh -c 'top -b'

CMD ["top", "-b"]
-> top -b
```
が実行されます。  
`ENTRYPOINT` を変更すると以下のように `CMD` は `ENTRYPOINT` の引数として機能します。

```
ENTRYPOINT ["top", "-b"]
CMD this_does_not_work
-> top -b /bin/sh -c this_does_not_work

ENTRYPOINT ["top", "-b"]
CMD ["-d1"]
-> top -b -d1
```

# 環境の切り替え方法

- 対象
  - database.yml
  - secrets.yml
- 環境
  - development
  - test (local)
  - test (CircleCI)
  - production
- 方法
  - development
    - database.yml -> fileで直接指定
    - secrets.yml -> fileで直接指定
  - test (local)
    - database.yml -> 環境変数`DATABASE_URL`を使う
      - 開発時に都度指定するのが面倒なので、direnvを使う
    - secrets.yml -> fileで直接指定
  - test (CircleCI)
    - database.yml -> 環境変数`DATABASE_URL`を使う
      - docker run --env DATABASE_URL=mysql2://myuser:mypass@localhost/somedatabase
    - secrets.yml -> fileで直接指定
  - production
    - database.yml -> 環境変数`DATABASE_URL`を使う
      - docker-compose.ymlで指定
    - secrets.yml -> 環境変数`SECRET_KEY_BASE`を使う
      - docker-compose.ymlで指定

## direnv
- http://direnv.net/
-
### install
```sh
brew install direnv
# or 
go get github.com/zimbatm/direnv
# or
git clone https://github.com/zimbatm/direnv
cd direnv
make install
```

### setup

~/.zshrc

```
eval "$(direnv hook zsh)"
```
~/.bash

```
eval "$(direnv hook bash)"
```


### how to use

```
direnv edit .
direnv allow
```

- .envrcには環境変数以外もかける
  - スクリプト
  - direnvのコマンド
    - layout program_name :その言語用の開発環境をセットアップする
    - PATH_add path: 環境変数PATHにpathを追加
    - path_add envname path: 環境変数envnameにpathを追加
  - その他: https://github.com/direnv/direnv/blob/master/man/direnv-stdlib.1.md



# ECS + S3でPrivate Docker Registoryをたてる

- S3
  - バケットを作成
- IAM
  - ユーザを作成
    - インラインポリシーでS3のこのバケットを読み書きするポリシーをあてる
    - アクセスキーIDとシークレットアクセスキーをメモ
  - ロールを作成
    - Amazon EC2 Role for EC2 Container Service をつける
- VPC
  - VPC
    - 172.13.0.0/16
  - Gateway
    - つくったらVPCへアタッチ
  - Subnet
    - 172.13.1.0/24
  - Routetable
    - ルートを編集
      - 0.0.0.0/0 -> Gateway
    - サブネットを関連付ける
  - セキュリティグループ
    - 22,5000,8080番ポートを空けとく
    - CircleCIからのアクセスを制御する場合
      - [AWSで別のアカウントのセキュリティグループを使う](http://qiita.com/71713@github/items/535105946803c3fa7c19)
      - [CircleCIからCapistranoを利用してAWS（EC2）にデプロイする](http://qiita.com/ryshinoz/items/85eecd2b860227a45ccd)
      - (https://circleci.com/docs/ec2ip-and-security-group)
- EC2
  - [Launching an Amazon ECS Container Instance](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html)
  - AMI
    - コミュニティAMIでamzn-ami-2015.03.d-amazon-ecs-optimizedを検索
    - ap-northeast-1の場合、ami-fa12b7fa
  - インスタンスタイプ
    - t2.micro
  - インスタンスの詳細
    - VPC
    - サブネット
    - 自動割り当てパブリック IPを有効化
    - 高度な詳細>ユーザーデータ
    - `#!/bin/bash`
    - `echo ECS_CLUSTER=your_cluster_name >> /etc/ecs/ecs.config`
- ECS
  - docker-registry用クラスタを作る
  - タスクを定義する
    - タスクとはdocker-compose.ymlのように、複数コンテナ間のリンクやホストとのポートマッピングなどの設定
    - CPU Unitsという単位
      - vCPU1つあたり1024
    - docker-registry用コンテナ
      - Container name : docker-registry
      - Image : registry:latest
      - Memory : 512
      - CPU Units : 10
      - Essential : on
      - PortMappings
        - 5000:5000 /tcp
      - Environment Variables
        - AWS_KEY : S3へアクセス権限を持つユーザのアクセスID
        - AWS_SECRET : S3へアクセス権限を持つユーザのシークレットアクセスキー
        - AWS_BUCKET : S3のバケット名
        - SETTING_FLAVOR : s3
        - STORAGE_PATH : /registry S3バケット上のパス
        - SEARCH_BACKEND : sqlalchemy 検索バックエンド
    - docker-registry-frontend用コンテナ
      - Container name : docker-registry-frontend
      - Image : konradkleine/docker-registry-frontend
      - Memory : 448
      - CPU Units : 10
      - Essential : on
      - PortMappings
        - 8080:80 /tcp
      - Environment Variables
        - ENV_DOCKER_REGISTRY_HOST : docker-registry
          - docker-registryコンテナのホスト名
          - ここではリンクしているdocker-registry用コンテナの名前
        - ENV_DOCKER_REGISTRY_PORT : 5000
          - docker-registryコンテナのポート番号
      - Links : docker-registry
  - タスクをサービスにする
    - 1回だけ実行するのがタスク、常時実行するのがサービス
    - Task Definitionsからタスクを選んでActions > Create Service

## boot2dockerからpushしてみる

```sh
# ビルド
docker build -t violetyk/rails-sample .

# タグ付け
# docker tag IMAGE REPOSITORY[:TAG] tagを省略するとlatest
docker tag violetyk/rails-sample YOUR_REGISTRY_HOST:5000/violetyk/rails-sample

# latestの他にコミットIDでタグ付けしておくと、そのコミットのコンテナがわかるからいざというとき便利
docker tag violetyk/rails-sample YOUR_REGISTRY_HOST:5000/violetyk/rails-sample:$(git log -n 1 --format=%H)

# 確認
$ docker images
REPOSITORY                                 TAG                                        IMAGE ID            CREATED             VIRTUAL SIZE
YOUR_REGISTRY_HOST:5000/violetyk/rails-sample   latest                                     a64aa04295eb        19 minutes ago      914.6 MB
YOUR_REGISTRY_HOST:5000/violetyk/rails-sample   726a37ff47ed7c494440e8873abb3fe89f25ee94   a64aa04295eb        19 minutes ago      914.6 MB
violetyk/rails-sample                      latest                                     a64aa04295eb        19 minutes ago      914.6 MB

# push
# docker push YOUR_REGISTRY_HOST:5000/violetyk/rails-sample # HTTPSアクセスしようとしてエラーになる...
# ところで、http://YOUR_REGISTRY_HOST:5000/v1/_pingにアクセスするとdocker-registryの情報がいろいろ確認できるぽい

# /var/lib/boot2docker/profileファイルに設定を追加
boot2docker ssh "echo $'EXTRA_ARGS=\"--insecure-registry YOUR_REGISTRY_HOST:5000\"' | sudo tee -a /var/lib/boot2docker/profile && sudo /etc/init.d/docker restart"
```

さっき立てたdocker-registry-frontend `http://YOUR_REGISTRY_HOST:8080` にアクセスするとpushされたイメージが確認できる

## クラスタを削除

AWS マネジメントコンソールからServiceを削除仕様とするとエラーになって削除できない...

```
 Unable to delete service
 The service cannot be stopped while the primary deployment is scaled above 0.
```

CLI でサービスを消してから Clusterを消すとイケる？
```
aws ecs update-service --service service-docker-registry --desired-count 0
```


## registry:2.0でやってみる

https://github.com/docker/distribution/blob/master/docs/configuration.md#override-configuration-options




## CircleCIからpushしてみる
